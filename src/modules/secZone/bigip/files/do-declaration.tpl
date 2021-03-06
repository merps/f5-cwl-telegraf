#cloud-config
chpasswd:
  list: |
    root:${admin_pwd}
    admin:${root_pwd}
  expire: False
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.21.0/f5-appsvcs-3.21.0-4.noarch.rpm"
    - "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.9.0/f5-declarative-onboarding-1.9.0-1.noarch.rpm"
    - "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.14.0/f5-telemetry-1.14.0-2.noarch.rpm"
  do_declaration:
    schemaVersion: 1.0.0
    class: Device
    async: true
    label: cloud-init DO
    Common:
      class: Tenant
      provisioningLevels:
        class: Provision
        ltm: nominal
        asm: nominal
      dnsServers:
        class: DNS
        nameServers:
          - 107.162.158.150
          - 107.162.158.151
          - 8.8.8.8
        search:
          - ec2.internal
          - compute-1.internal
          - f5cs.tech
      ntpServers:
        class: NTP
        servers:
          - 169.254.169.123
      external:
        class: VLAN
        interfaces:
          - name: 1.1
            tagged: false
      external-self:
        class: SelfIp
        address: ${extSelfIP}
        vlan: external
        allowService: none
        trafficGroup: traffic-group-local-only
      internal:
        class: VLAN
        interfaces:
          - name: 1.2
            tagged: false
      internal-self:
        class: SelfIp
        address: ${intSelfIP}
        vlan: internal
        allowService: default
        trafficGroup: traffic-group-local-only
      dbvars:
        class: DbVariables
        ui.advisory.enabled: true
        ui.advisory.color: orange
        ui.advisory.text: cloud-init config
  as3_declaration:
    class: ADC
    schemaVersion: 3.10.0
    Common:
      Shared:
        class: Application
        template: shared
        telemetry:
          class: Pool
          members:
            - servicePort: 6514
              serverAddresses:
                - 255.255.255.254
          monitors:
            - bigip: /Common/tcp
        telemetry_formatted:
          class: Log_Destination
          forwardTo:
            use: telemetry_hsl
          type: splunk
        telemetry_hsl:
          class: Log_Destination
          pool:
            use: telemetry
          protocol: tcp
          type: remote-high-speed-log
        telemetry_local:
          class: Service_TCP
          iRules:
            - telemetry_local_rule
          virtualAddresses:
            - 255.255.255.254
          virtualPort: 6514
        telemetry_local_rule:
          class: iRule
          iRule: |-
              when CLIENT_ACCEPTED {
                node 127.0.0.1 6514
              }
        telemetry_publisher:
          class: Log_Publisher
          destinations:
            - use: telemetry_formatted
        telemetry_security_log_profile:
          application:
            localStorage: false
            protocol: tcp
            remoteStorage: splunk
            servers:
              - address: "255.255.255.254"
                port: "6514"
            storageFilter:
              requestType: illegal-including-staged-signatures
          class: Security_Log_Profile
        telemetry_traffic_log_profile:
          class: Traffic_Log_Profile
          requestSettings:
            requestEnabled: true
            requestPool:
              use: telemetry
            requestProtocol: mds-tcp
            requestTemplate: "event_source=\"request_logging\",hostname=\"$BIGIP_HOSTNAME\",client_ip=\"$CLIENT_IP\",server_ip=\"$SERVER_IP\",http_method=\"$HTTP_METHOD\",http_uri=\"$HTTP_URI\",virtual_name=\"$VIRTUAL_NAME\",date_time=\"$DATE_HTTP\""
  post_onboard_enabled: false