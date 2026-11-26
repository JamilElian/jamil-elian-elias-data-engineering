# Get Started with Virtual Private Cloud Networking and Compute Engine

## Overview

**Google Cloud Virtual Private Cloud (VPC)** provides global networking functionality to **Compute Engine** virtual machine (VM) instances, **Google Kubernetes Engine (GKE)** containers, and **App Engine** flexible environments. Because Compute Engine resources cannot be provisioned without an active VPC network, every Google Cloud project includes a pre-configured `default` network.

In this lab, the `default` VPC network (subnets, routes, and firewall rules) is inspected and deleted to verify Compute Engine network dependencies, an auto-mode VPC network (`mynetwork`) is created from scratch, two VM instances are deployed across separate regions (`asia-east1` and `us-central1`), and internal/external connectivity is tested while progressively removing firewall rules (`allow-icmp`, `allow-custom`, and `allow-ssh`).

---

## Lab Objectives

* Explore the `default` VPC network (regional subnets, routing tables, and ingress/egress firewall rules).
* Verify that Compute Engine prevents VM creation when no VPC network exists in the project.
* Create an auto-mode VPC network (`mynetwork`) with standard IPv4 firewall rules.
* Provision multi-region Compute Engine VM instances (`mynet-us-vm` and `mynet-r2-vm`).
* Test internal and external ICMP/SSH connectivity and evaluate the impact of removing individual firewall rules.

---

## Network Topology & Firewall Architecture

### VPC & Compute Engine Resources

| Resource | Type / Role | Region / Zone | CIDR / IP Details |
| :--- | :--- | :--- | :--- |
| **`mynetwork`** | Auto-mode VPC Network (`MTU 1460`, Regional routing) | Global (24 regional subnets) | RFC 1918 private ranges (`10.128.0.0/9` overall) |
| **Subnet 1 (`asia-east1`)** | Regional Virtual Subnetwork | `asia-east1` (Taiwan) | `10.140.0.0/20` |
| **Subnet 2 (`us-central1`)** | Regional Virtual Subnetwork | `us-central1` (Iowa) | `10.128.0.0/20` |
| **`mynet-us-vm`** | Compute Engine VM (`e2-micro`, 2 vCPU, 1 GB RAM) | `asia-east1-b` | Internal IP: `10.140.0.2` \| Ephemeral External IP: `35.189.164.196` |
| **`mynet-r2-vm`** | Compute Engine VM (`e2-micro`, 2 vCPU, 1 GB RAM) | `us-central1-a` | Internal IP: `10.128.0.2` \| Ephemeral External IP: `34.45.1.100` |

### Firewall Rules & Connectivity Impact Matrix

Every VPC network includes two implied rules (`deny-all-ingress` and `allow-all-egress` at priority `65535`). Higher-priority (`65534`) explicit rules govern allowed traffic:

| Firewall Rule | Direction | Source Filter | Protocol / Port | Connectivity Impact Tested in Lab |
| :--- | :--- | :--- | :--- | :--- |
| **`mynetwork-allow-custom`** | Ingress | `10.128.0.0/9` (Internal VPC) | All (`tcp`, `udp`, `icmp`) | Allows internal cross-region `ping` (`10.140.0.2` ↔ `10.128.0.2`). Removing it causes `100% packet loss` on internal IPs. |
| **`mynetwork-allow-icmp`** | Ingress | `0.0.0.0/0` (Any) | `icmp` | Allows external `ping` to ephemeral public IPs (`34.45.1.100`). Removing it causes `100% packet loss` on external IPs. |
| **`mynetwork-allow-ssh`** | Ingress | `0.0.0.0/0` (Any) | `tcp:22` | Allows **SSH-in-browser** (via Cloud IAP / public IP). Removing it blocks SSH connections (*Establishing connection...* timeout). |
| **`mynetwork-allow-rdp`** | Ingress | `0.0.0.0/0` (Any) | `tcp:3389` | Permits Remote Desktop Protocol (RDP) ingress traffic. |

---

## Step-by-Step Execution & Verification Evidence

### Task 1: Explore & Delete the `default` VPC Network

1. **Lab Initialization:** Launched the sandbox environment in `asia-east1` (`asia-east1-b`) and retrieved temporary credentials.
   ![Lab Setup and Credentials](screenshots/01_lab_setup_and_credentials.PNG)

2. **GCP Account Welcome:** Accepted the initial Google Workspace/Cloud sandbox account notice.
   ![GCP Account Welcome](screenshots/02_gcp_account_welcome.PNG)

3. **Terms of Service Agreement:** Agreed to the Google Cloud Platform Terms of Service.
   ![GCP Terms of Service](screenshots/03_gcp_terms_of_service.PNG)

4. **Navigating to VPC Networks:** Opened **VPC Network → VPC networks** from the navigation menu.
   ![GCP Console VPC Network Menu](screenshots/04_gcp_console_vpc_network_menu.PNG)

5. **Inspecting the `default` Network:** Observed the pre-provisioned `default` auto-mode network with 24 subnets, `MTU 1460`, and 6 firewall rules.
   ![VPC Networks Default Overview](screenshots/05_vpc_networks_default_overview.PNG)

6. **Default VPC Network Details:** Reviewed auto-subnet creation mode and regional dynamic routing configuration.
   ![Default VPC Network Details](screenshots/06_default_vpc_network_details.PNG)

7. **Default Subnets Inspection:** Verified regional subnets, including `asia-east1` (`10.140.0.0/20`), and navigated to **Routes**.
   ![Default VPC Subnets](screenshots/07_default_vpc_subnets.PNG)

8. **Effective Routes Filter:** Filtered routes for network `default` in region `asia-east1 (Taiwan)`.
   ![VPC Effective Routes Filter](screenshots/08_vpc_effective_routes_filter.PNG)

9. **Default Routing Table:** Verified the static default route (`0.0.0.0/0` via Default internet gateway, priority `1000`) and internal subnet routes (priority `0`).
   ![VPC Routes List](screenshots/09_vpc_routes_list.PNG)

10. **Default Firewall Rules:** Inspected all 6 pre-provisioned rules (4 ingress: `default-allow-icmp`, `default-allow-internal`, `default-allow-rdp`, `default-allow-ssh`; 2 egress: `allow-http-https-dns-egress`, `deny-all-egress`).
    ![VPC Firewall Rules](screenshots/10_vpc_firewall_rules.PNG)

11. **Selecting All Firewall Rules:** Selected all 6 firewall rules associated with the `default` network (Google Cloud blocks deleting a VPC while firewall rules remain attached).
    ![Select All Firewall Rules Delete](screenshots/11_select_all_firewall_rules_delete.PNG)

12. **Firewall Rules Deleted:** Confirmed deletion of all firewall rules and returned to **VPC networks**.
    ![Firewall Rules Deleted](screenshots/12_firewall_rules_deleted.PNG)

13. **Verifying Zero Firewall Rules:** Confirmed the `default` network showed `0` active firewall rules.
    ![Default VPC Zero Firewall Rules](screenshots/13_default_vpc_zero_firewall_rules.PNG)

14. **Initiating VPC Deletion:** Opened the `default` network details and clicked **Delete VPC network**.
    ![Default VPC Delete Button](screenshots/14_default_vpc_delete_button.PNG)

15. **Confirming Network Deletion:** Typed `default` to confirm permanent deletion of the network and its subnets/routes.
    ![Confirm Delete Default Network](screenshots/15_confirm_delete_default_network.PNG)

16. **Network & Routes Removed:** Confirmed *"Successfully deleted network"* and verified that no routes remained.
    ![VPC Network Deleted No Routes](screenshots/16_vpc_network_deleted_no_routes.PNG)

17. **Firewall Policies Empty:** Verified that no firewall rules or policies remained in the project.
    ![Firewall Policies Empty](screenshots/17_firewall_policies_empty.PNG)

18. **Navigating to Compute Engine:** Opened **Compute Engine → VM instances** from the navigation menu.
    ![Navigate Compute Engine VM Instances](screenshots/18_navigate_compute_engine_vm_instances.PNG)

19. **Attempting VM Creation Without a VPC:** Clicked **Create instance** in Compute Engine.
    ![Compute Engine Create Instance](screenshots/19_compute_engine_create_instance.PNG)

20. **Networking Validation Error:** Observed the form error (*"Networking: Some form fields are incorrect"*), proving that a VM cannot be created without a VPC network.
    ![Create VM Error Without VPC](screenshots/20_create_vm_error_without_vpc.PNG)

21. **Inspecting Form Issues:** Clicked **Go to issue(s)** to examine the networking validation error.
    ![VM Creation Go to Issues](screenshots/21_vm_creation_go_to_issues.PNG)

22. **No Networks Available:** Confirmed *"No more networks available in this project"* under **Edit network interface** and canceled VM creation.
    ![VM Network Interface No Networks](screenshots/22_vm_network_interface_no_networks.PNG)

---

### Task 2: Create an Auto-Mode VPC Network & Multi-Region VM Instances

23. **Returning to VPC Networks:** Navigated back to **VPC Network → VPC networks**.
    ![Navigate Back to VPC Networks](screenshots/23_navigate_back_to_vpc_networks.PNG)

24. **Creating a New VPC Network:** Clicked **Create VPC network**.
    ![Click Create VPC Network](screenshots/24_click_create_vpc_network.PNG)

25. **Configuring `mynetwork`:** Named the VPC `mynetwork` and selected **Automatic** subnet creation mode.
    ![Create mynetwork Auto Mode](screenshots/25_create_mynetwork_auto_mode.PNG)

26. **Previewing Automatic Subnets:** Reviewed the automatically assigned regional IPv4 CIDR ranges.
    ![mynetwork Automatic Subnets Preview](screenshots/26_mynetwork_automatic_subnets_preview.PNG)

27. **Selecting Predefined Firewall Rules:** Enabled `mynetwork-allow-custom`, `mynetwork-allow-icmp`, `mynetwork-allow-rdp`, and `mynetwork-allow-ssh`.
    ![mynetwork Default Firewall Rules](screenshots/27_mynetwork_default_firewall_rules.PNG)

28. **Finalizing VPC Creation:** Kept **Regional** dynamic routing mode and clicked **Create**.
    ![mynetwork Routing and Create](screenshots/28_mynetwork_routing_and_create.PNG)

29. **`mynetwork` Provisioned:** Confirmed *"Successfully created network 'mynetwork'"* with 24 subnets and 4 firewall rules.
    ![mynetwork Created Confirmation](screenshots/29_mynetwork_created_confirmation.PNG)

30. **Inspecting `mynetwork` Subnets:** Opened the **Subnets** tab of `mynetwork`.
    ![mynetwork Subnets Details](screenshots/30_mynetwork_subnets_details.PNG)

31. **Verifying `asia-east1` Subnet:** Confirmed CIDR range `10.140.0.0/20` for `asia-east1`.
    ![mynetwork Subnet asia-east1](screenshots/31_mynetwork_subnet_asia_east1.PNG)

32. **Verifying `us-central1` Subnet:** Confirmed CIDR range `10.128.0.0/20` for `us-central1`.
    ![mynetwork Subnet us-central1](screenshots/32_mynetwork_subnet_us_central1.PNG)

33. **Navigating to Compute Engine:** Opened **Compute Engine → VM instances**.
    ![Navigate to Compute Engine VMs](screenshots/33_navigate_to_compute_engine_vms.PNG)

34. **Creating First VM Instance:** Clicked **Create instance** to deploy `mynet-us-vm`.
    ![Click Create Instance mynet-us](screenshots/34_click_create_instance_mynet_us.PNG)

35. **Configuring `mynet-us-vm`:** Set name `mynet-us-vm`, region `asia-east1 (Taiwan)`, and zone `asia-east1-b` (automatically bound to `mynetwork`).
    ![Create mynet-us-vm Config](screenshots/35_create_mynet_us_vm_config.PNG)

36. **Machine Type & Creation (`mynet-us-vm`):** Selected `E2` series (`e2-micro`) and clicked **Create**.
    ![mynet-us-vm Machine Type Create](screenshots/36_mynet_us_vm_machine_type_create.PNG)

37. **`mynet-us-vm` Running:** Confirmed `mynet-us-vm` was active (`10.140.0.2`) and clicked **Create instance** for the second VM.
    ![mynet-us-vm Running Create Second](screenshots/37_mynet_us_vm_running_create_second.PNG)

38. **Configuring `mynet-r2-vm`:** Set name `mynet-r2-vm`, region `us-central1 (Iowa)`, and zone `us-central1-a`.
    ![Create mynet-r2-vm Config](screenshots/38_create_mynet_r2_vm_config.PNG)

39. **Machine Type & Creation (`mynet-r2-vm`):** Selected `E2` series (`e2-micro`) and clicked **Create**.
    ![mynet-r2-vm Machine Type Create](screenshots/39_mynet_r2_vm_machine_type_create.PNG)

40. **Both VMs Active in `mynetwork`:** Verified both `mynet-r2-vm` (`10.128.0.2`) and `mynet-us-vm` (`10.140.0.2`) running across regions with ephemeral external IPs.
    ![Both VMs Running in mynetwork](screenshots/40_both_vms_running_in_mynetwork.PNG)

41. **Task 2 Checkpoint Verified:** Validated **Create a VPC network and VM instance** (*Assessment Completed!*, `Score: 100 / 100`).
    ![Qwiklabs Task 2 Verified Score 100](screenshots/41_qwiklabs_task2_verified_score_100.PNG)

---

### Task 3: Explore VM Connectivity & Firewall Rule Impact

42. **Navigating to VM Instances:** Opened **Compute Engine → VM instances** to begin connectivity tests.
    ![Navigate Compute Engine Connectivity](screenshots/42_navigate_compute_engine_connectivity.PNG)

43. **Launching SSH Session:** Noted `mynet-r2-vm` internal IP (`10.128.0.2`) and clicked **SSH** on `mynet-us-vm`.
    ![VM Instances SSH mynet-us](screenshots/43_vm_instances_ssh_mynet_us.PNG)

44. **Authorizing SSH-in-Browser:** Authorized the browser SSH connection to `mynet-us-vm`.
    ![SSH in Browser Authorize](screenshots/44_ssh_in_browser_authorize.PNG)

45. **Testing Internal IP Ping:** Ran `ping -c 3 10.128.0.2` from `mynet-us-vm` to `mynet-r2-vm`.
    ![Ping Internal IP Command](screenshots/45_ping_internal_ip_command.PNG)

46. **Internal Connectivity Verified:** Confirmed `0% packet loss` across regions via `mynetwork-allow-custom`.
    ![Ping Internal IP Success](screenshots/46_ping_internal_ip_success.PNG)

47. **Testing External IP Ping:** Ran `ping -c 3 34.45.1.100` targeting `mynet-r2-vm`'s ephemeral external IP.
    ![Ping External IP Command](screenshots/47_ping_external_ip_command.PNG)

48. **External ICMP Connectivity Verified:** Confirmed `0% packet loss` via `mynetwork-allow-icmp`.
    ![Ping External IP Success](screenshots/48_ping_external_ip_success.PNG)

49. **Knowledge Check Verified:** Confirmed `mynetwork-allow-icmp` as the firewall rule permitting external ICMP traffic.
    ![Quiz Firewall Rule ICMP Verified](screenshots/49_quiz_firewall_rule_icmp_verified.PNG)

50. **Navigating to Firewall Rules:** Opened **VPC Network → Firewall** to test removing `allow-icmp`.
    ![Navigate VPC Network Firewall](screenshots/50_navigate_vpc_network_firewall.PNG)

51. **Selecting `mynetwork-allow-icmp`:** Selected `mynetwork-allow-icmp` and clicked **Delete**.
    ![Select allow-icmp Rule Delete](screenshots/51_select_allow_icmp_rule_delete.PNG)

52. **`mynetwork-allow-icmp` Deleted:** Confirmed deletion of the ICMP rule while keeping `allow-custom`, `allow-rdp`, and `allow-ssh`.
    ![allow-icmp Rule Deleted](screenshots/52_allow_icmp_rule_deleted.PNG)

53. **Re-testing Internal IP Ping:** Executed `ping -c 3 10.128.0.2` after removing `allow-icmp`.
    ![Ping Internal IP After ICMP Delete Cmd](screenshots/53_ping_internal_ip_after_icmp_delete_cmd.PNG)

54. **Internal Ping Still Succeeds:** Confirmed `0% packet loss` because `mynetwork-allow-custom` still allows internal VPC traffic.
    ![Ping Internal IP After ICMP Delete Success](screenshots/54_ping_internal_ip_after_icmp_delete_success.PNG)

55. **Re-testing External IP Ping:** Executed `ping -c 3 34.45.1.100` after removing `allow-icmp`.
    ![Ping External IP After ICMP Delete Cmd](screenshots/55_ping_external_ip_after_icmp_delete_cmd.PNG)

56. **External Ping Blocked:** Confirmed `100% packet loss` on the external IP without `mynetwork-allow-icmp`.
    ![Ping External IP After ICMP Delete Blocked](screenshots/56_ping_external_ip_after_icmp_delete_blocked.PNG)

57. **Navigating to Firewall to Remove `allow-custom`:** Opened **VPC Network → Firewall**.
    ![Navigate Firewall Delete allow-custom](screenshots/57_navigate_firewall_delete_allow_custom.PNG)

58. **Selecting `mynetwork-allow-custom`:** Selected `mynetwork-allow-custom` and clicked **Delete**.
    ![Select allow-custom Rule Delete](screenshots/58_select_allow_custom_rule_delete.PNG)

59. **`mynetwork-allow-custom` Deleted:** Confirmed deletion of the internal traffic rule.
    ![allow-custom Rule Deleted](screenshots/59_allow_custom_rule_deleted.PNG)

60. **Re-testing Internal IP Ping Command:** Prepared `ping -c 3 10.128.0.2` after removing `allow-custom`.
    ![Ping Internal IP After Custom Delete Cmd](screenshots/60_ping_internal_ip_after_custom_delete_cmd.PNG)

61. **Internal Ping Blocked:** Confirmed `100% packet loss` between VMs in the same VPC once `mynetwork-allow-custom` was removed.
    ![Ping Internal IP After Custom Delete Blocked](screenshots/61_ping_internal_ip_after_custom_delete_blocked.PNG)

62. **Exiting SSH Session:** Closed the active SSH session (`exit`).
    ![SSH Exit Session](screenshots/62_ssh_exit_session.PNG)

63. **Navigating to Firewall to Remove `allow-ssh`:** Opened **VPC Network → Firewall**.
    ![Navigate Firewall Delete allow-ssh](screenshots/63_navigate_firewall_delete_allow_ssh.PNG)

64. **Selecting `mynetwork-allow-ssh`:** Selected `mynetwork-allow-ssh` (`tcp:22`) and clicked **Delete**.
    ![Select allow-ssh Rule Delete](screenshots/64_select_allow_ssh_rule_delete.PNG)

65. **`mynetwork-allow-ssh` Deleted:** Confirmed deletion of the SSH ingress rule.
    ![allow-ssh Rule Deleted](screenshots/65_allow_ssh_rule_deleted.PNG)

66. **Returning to Compute Engine:** Navigated back to **Compute Engine → VM instances**.
    ![Navigate Compute Engine Test SSH Blocked](screenshots/66_navigate_compute_engine_test_ssh_blocked.PNG)

67. **Attempting SSH Connection:** Clicked **SSH** on `mynet-us-vm`.
    ![Click SSH mynet-us After Rule Delete](screenshots/67_click_ssh_mynet_us_after_rule_delete.PNG)

68. **Authorizing SSH Test:** Clicked **Authorize** in the SSH-in-browser prompt.
    ![SSH in Browser Authorize Blocked Test](screenshots/68_ssh_in_browser_authorize_blocked_test.PNG)

69. **SSH Connection Blocked:** Verified that SSH hangs on *"Establishing connection to SSH server..."* without an ingress rule allowing `tcp:22`.
    ![SSH Connection Hanging Blocked](screenshots/69_ssh_connection_hanging_blocked.PNG)

70. **Lab Completion:** Finished the lab with a final score of **100 / 100**.
    ![Lab Completed Score 100/100](screenshots/70_lab_completed_score_100_100.PNG)
