# WiFiCallBypass

This script enables **tunneling of Wi-Fi Calling traffic over an SSH tunnel**.  
It is useful if your mobile provider blocks Wi-Fi Calling outside your home country (for example, due to IP geoblocking).

## Why Use This?

Some mobile providers restrict Wi-Fi Calling to users within their home country by blocking connections from foreign IP addresses.  
By tunneling your Wi-Fi Calling traffic through an SSH server in your home country, you can bypass these restrictions and use Wi-Fi Calling from anywhere.

## Features

- Tunnels Wi-Fi Calling traffic over SSH
- Helps bypass IP-based geoblocking by mobile providers

## Usage

1. **Ensure you have an SSH server in your home country.**  
   This is necessary to tunnel your Wi-Fi Calling traffic through a trusted location.

2. **Connect your phone to the Wi-Fi network you created (AP).**  
   For example, you can use a tool like [linux-wifi-hotspot](https://github.com/lakinduakash/linux-wifi-hotspot) to set up your access point.

3. **Run the script on your device or router.**  
    The script must be executed with root privileges.

4. **Specify required parameters when running the script:**  
   The script uses named parameters, so you can provide them in any order.  
   - `--mnc `: Mobile Network Code (e.g., `001`) of your provider, according to [https://www.mcc-mnc.com/](https://www.mcc-mnc.com/)
   - `--mcc `: Mobile Country Code (e.g., `228`) of your provider, according to [https://www.mcc-mnc.com/](https://www.mcc-mnc.com/)
   - `--ssh `: SSH connection string (e.g., `user@host`)
   - `--tmark `: (Optional) Firewall mark for TPROXY (default: `0x01`)

   **Example:**
   ```bash
   sudo ./WiFiCallBypass.sh --mnc 001 --mcc 228 --ssh user@your-ssh-server
   ```
   Or with a custom TPROXY mark:
   ```bash
   sudo ./WiFiCallBypass.sh --ssh user@your-ssh-server --mnc 001 --mcc 228 --tmark 0xAD
   ```

5. **Verify connectivity from your phone:**  
   - Check that Wi-Fi Calling is enabled and works as expected.

### Notes

- The script will automatically configure routing and policy rules for transparent proxying.

## Requirements

- sshuttle (or similar tunneling tool)
- Root privileges (required for network configuration)

## Disclaimer

This software is provided "AS IS" for educational and research purposes only. Users are solely responsible for ensuring their use complies with applicable laws, regulations, and service provider terms of service. The author(s) assume no responsibility for any consequences resulting from the use of this software, including but not limited to service termination, legal action, or other penalties.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
