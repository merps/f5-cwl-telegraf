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
          - 169.254.169.254
          - 107.162.158.150
          - 107.162.158.151
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
  post_onboard_enabled: false