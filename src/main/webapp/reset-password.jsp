<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password — Elective Recommendation System</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;min-height:100vh;display:flex;background:#f0f2ff;justify-content:center;align-items:center;}
.card{background:#fff;border:1px solid #e8e8f0;border-radius:20px;padding:36px 38px;width:100%;max-width:420px;position:relative;box-shadow:0 8px 40px rgba(83,74,183,.08);}
.card-accent{height:4px;background:#534AB7;border-radius:4px 4px 0 0;position:absolute;top:0;left:0;right:0;}
.logo{display:flex;align-items:center;gap:8px;margin-bottom:28px;}
.logo-mark{width:30px;height:30px;background:#534AB7;border-radius:8px;display:flex;align-items:center;justify-content:center;}
.logo-mark svg{width:14px;height:14px;}
.logo-text{font-size:13px;font-weight:700;color:#1a1a2e;}
.logo-text span{color:#534AB7;}
.card-title{font-size:22px;font-weight:800;color:#1a1a2e;margin-bottom:4px;letter-spacing:-.02em;}
.card-sub{font-size:13px;color:#9ca3af;margin-bottom:28px;}
.field{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
.field label{font-size:11px;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.05em;}
.input-wrap{position:relative;}
.input-wrap svg{position:absolute;left:12px;top:50%;transform:translateY(-50%);width:14px;height:14px;color:#9ca3af;pointer-events:none;}
.field input{width:100%;padding:10px 12px 10px 36px;border:1.5px solid #e0e0f0;border-radius:9px;font-size:13px;color:#1a1a2e;background:#fafafa;outline:none;font-family:inherit;transition:border-color .15s,box-shadow .15s;}
.field input:focus{border-color:#534AB7;background:#fff;box-shadow:0 0 0 3px #EEEDFE;}
.strength-bar{height:4px;border-radius:4px;background:#e0e0f0;margin-top:6px;overflow:hidden;}
.strength-fill{height:100%;border-radius:4px;width:0%;transition:width .3s,background .3s;}
.strength-label{font-size:11px;color:#9ca3af;margin-top:4px;}
.btn-submit{width:100%;padding:11px;background:#534AB7;color:#fff;border:none;border-radius:9px;font-size:14px;font-weight:700;cursor:pointer;transition:background .15s;margin-top:6px;letter-spacing:.01em;}
.btn-submit:hover{background:#3C3489;}
.error-box{display:flex;align-items:center;gap:8px;background:#FEE2E2;border:1px solid #FECACA;border-radius:9px;padding:10px 14px;margin-bottom:16px;font-size:13px;color:#991B1B;}
</style>
</head>
<body>
<div class="card">
    <div class="card-accent"></div>
    <div class="logo">
        <div class="logo-mark">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="2" width="5" height="5" rx="1.5" fill="white"/><rect x="9" y="2" width="5" height="5" rx="1.5" fill="white" opacity=".5"/><rect x="2" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".5"/><rect x="9" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".75"/></svg>
        </div>
        <span class="logo-text">Elective <span>System</span></span>
    </div>
    <div class="card-title">Reset Password</div>
    <div class="card-sub">Choose a strong new password for your account</div>

    <% String error = (String) request.getAttribute("error"); %>
    <% if(error != null){ %>
        <div class="error-box"><svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" stroke="#991B1B" stroke-width="1.4"/><path d="M8 5v3M8 10.5v.5" stroke="#991B1B" stroke-width="1.5" stroke-linecap="round"/></svg><%= error %></div>
    <% } %>

    <form action="reset-password" method="post">
        <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
        <div class="field">
            <label>New Password</label>
            <div class="input-wrap">
                <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7V5a3 3 0 0 1 6 0v2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                <input type="password" name="newPassword" id="newPass" placeholder="Enter new password" required oninput="checkStrength(this.value)">
            </div>
            <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
            <span class="strength-label" id="strengthLabel"></span>
        </div>
        <div class="field">
            <label>Confirm Password</label>
            <div class="input-wrap">
                <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7V5a3 3 0 0 1 6 0v2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                <input type="password" name="confirmPassword" placeholder="Confirm new password" required>
            </div>
        </div>
        <button type="submit" class="btn-submit">Reset Password</button>
    </form>
</div>
<script>
function checkStrength(val) {
    const fill = document.getElementById('strengthFill');
    const label = document.getElementById('strengthLabel');
    let score = 0;
    if(val.length >= 8) score++;
    if(/[A-Z]/.test(val)) score++;
    if(/[0-9]/.test(val)) score++;
    if(/[^A-Za-z0-9]/.test(val)) score++;
    const colors = ['#ef4444','#f97316','#eab308','#22c55e'];
    const labels = ['Weak','Fair','Good','Strong'];
    const widths = ['25%','50%','75%','100%'];
    if(val.length === 0){ fill.style.width='0%'; label.textContent=''; return; }
    fill.style.background = colors[score-1] || colors[0];
    fill.style.width = widths[score-1] || widths[0];
    label.textContent = labels[score-1] || labels[0];
}
</script>
</body>
</html>