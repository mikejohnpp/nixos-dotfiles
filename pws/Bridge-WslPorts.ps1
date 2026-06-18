# Cổng TCP (dùng portproxy như cũ)
$tcpPorts = @(80, 443, 6443, 8080)
# Cổng UDP (chỉ mở firewall ở Windows; forward thật làm bằng socat trong WSL)
$udpPorts = @(8472)   # đổi theo nhu cầu của bạn

$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "WSL IP address: $wslAddress" -ForegroundColor Green
  Write-Host "TCP Ports: $tcpPorts" -ForegroundColor Green
  Write-Host "UDP Ports: $udpPorts" -ForegroundColor Green
}
else {
  Write-Host "Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

$listenAddress = '0.0.0.0'

# --- TCP: portproxy (chuyển tiếp thật) ---
foreach ($port in $tcpPorts) {
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$listenAddress"
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$listenAddress connectport=$port connectaddress=$wslAddress"
}

# --- Firewall ---
$tcpRuleName = 'WSL Port Forwarding TCP'
$udpRuleName = 'WSL Port Forwarding UDP'
$tcpPortsStr = $tcpPorts -join ","
$udpPortsStr = $udpPorts -join ","

Remove-NetFireWallRule -DisplayName $tcpRuleName -ErrorAction SilentlyContinue
Remove-NetFireWallRule -DisplayName $udpRuleName -ErrorAction SilentlyContinue

# TCP
New-NetFireWallRule -DisplayName $tcpRuleName -Direction Outbound -LocalPort $tcpPortsStr -Action Allow -Protocol TCP
New-NetFireWallRule -DisplayName $tcpRuleName -Direction Inbound  -LocalPort $tcpPortsStr -Action Allow -Protocol TCP
# UDP
New-NetFireWallRule -DisplayName $udpRuleName -Direction Outbound -LocalPort $udpPortsStr -Action Allow -Protocol UDP
New-NetFireWallRule -DisplayName $udpRuleName -Direction Inbound  -LocalPort $udpPortsStr -Action Allow -Protocol UDP

