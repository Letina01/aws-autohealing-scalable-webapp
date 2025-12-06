#!/bin/bash
dnf update -y
dnf install -y nginx

systemctl enable nginx

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "N/A")
HOSTNAME=$(hostname)

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
  <head>
    <title>Auto-Healing Scalable Web App</title>
    <style>
      body {
        margin: 0;
        font-family: system-ui, Arial, sans-serif;
        background: linear-gradient(135deg, #0f172a, #1e293b);
        color: #e5e7eb;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
      }
      .card {
        background: rgba(15, 23, 42, 0.9);
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 20px 40px rgba(0,0,0,0.5);
        width: 600px;
        text-align: center;
      }
      h1 { font-size: 28px; margin-bottom: 10px; }
      h2 { font-size: 18px; margin-bottom: 20px; color: #a5b4fc; }
      .meta { text-align: left; margin-top: 15px; }
      dt { font-weight: bold; color: #93c5fd; }
      dd { margin-bottom: 10px; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Auto-Healing Scalable Web App</h1>
      <h2>Behind ALB & Auto Scaling Group</h2>
      <dl class="meta">
        <dt>Instance ID</dt><dd>${INSTANCE_ID}</dd>
        <dt>Hostname</dt><dd>${HOSTNAME}</dd>
        <dt>Availability Zone</dt><dd>${AZ}</dd>
        <dt>Private IP</dt><dd>${LOCAL_IP}</dd>
        <dt>Public IP</dt><dd>${PUBLIC_IP}</dd>
      </dl>
    </div>
  </body>
</html>
EOF

systemctl restart nginx
