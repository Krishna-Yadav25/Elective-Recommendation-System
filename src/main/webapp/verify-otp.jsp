<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Verify OTP — Elective Recommendation System</title>
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
.otp-wrap{display:flex;gap:10px;justify-content:center;margin-bottom:22px;}
.otp-wrap input{width:52px;height:56px;text-align:center;font-size:22px;font-weight:700;border:1.5px solid #e0e0f0;border-radius:9px;outline:none;color:#1a1a2e;background:#fafafa;transition:border-color .15s,box-shadow .15s;}
.otp-wrap input:focus{border-color:#534AB7;background:#fff;box-shadow:0 0 0 3px #EEEDFE;}
.btn-submit{width:100%;padding:11px;background:#534AB7;color:#fff;border:none;border-radius:9px;font-size:14px;font-weight:700;cursor:pointer;transition:background .15s;letter-spacing:.01em;}
.btn-submit:hover{background:#3C3489;}
.resend-row{text-align:center;margin-top:16px;font-size:13px;color:#9ca3af;}
.resend-row a{color:#534AB7;font-weight:600;text-decoration:none;cursor:pointer;}
.back-link{text-align:center;margin-top:12px;font-size:13px;color:#9ca3af;}
.back-link a{color:#534AB7;font-weight:600;text-decoration:none;}
.error-box{display:flex;align-items:center;gap:8px;background:#FEE2E2;border:1px solid #FECACA;border-radius:9px;padding:10px 14px;margin-bottom:16px;font-size:13px;color:#991B1B;}
.timer{color:#534AB7;font-weight:700;}
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
    <div class="card-title">Enter OTP</div>
    <div class="card-sub">We sent a 6-digit code to your email. It expires in <span class="timer" id="timer">05:00</span></div>

    <% String error = (String) request.getAttribute("error"); %>
    <% if(error != null){ %>
        <div class="error-box"><svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" stroke="#991B1B" stroke-width="1.4"/><path d="M8 5v3M8 10.5v.5" stroke="#991B1B" stroke-width="1.5" stroke-linecap="round"/></svg><%= error %></div>
    <% } %>

    <form action="verify-otp" method="post" id="otpForm">
        <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
        <div class="otp-wrap">
            <input type="text" maxlength="1" class="otp-input" id="o1" inputmode="numeric">
            <input type="text" maxlength="1" class="otp-input" id="o2" inputmode="numeric">
            <input type="text" maxlength="1" class="otp-input" id="o3" inputmode="numeric">
            <input type="text" maxlength="1" class="otp-input" id="o4" inputmode="numeric">
            <input type="text" maxlength="1" class="otp-input" id="o5" inputmode="numeric">
            <input type="text" maxlength="1" class="otp-input" id="o6" inputmode="numeric">
        </div>
        <input type="hidden" name="otp" id="otpHidden">
        <button type="submit" class="btn-submit">Verify OTP</button>
    </form>
    <div class="resend-row">Didn't get the code? <a onclick="resendOtp()">Resend OTP</a></div>
    <div class="back-link"><a href="forgot-password.jsp">← Change Email</a></div>
</div>
<script>
// Auto-focus next input
const inputs = document.querySelectorAll('.otp-input');
inputs.forEach((inp, i) => {
    inp.addEventListener('input', () => {
        if(inp.value && i < inputs.length - 1) inputs[i+1].focus();
    });
    inp.addEventListener('keydown', e => {
        if(e.key === 'Backspace' && !inp.value && i > 0) inputs[i-1].focus();
    });
});

// Combine OTP before submit
document.getElementById('otpForm').addEventListener('submit', function() {
    let otp = '';
    inputs.forEach(i => otp += i.value);
    document.getElementById('otpHidden').value = otp;
});

// Countdown timer
let secs = 300;
const timerEl = document.getElementById('timer');
const interval = setInterval(() => {
    secs--;
    const m = String(Math.floor(secs/60)).padStart(2,'0');
    const s = String(secs%60).padStart(2,'0');
    timerEl.textContent = m + ':' + s;
    if(secs <= 0){ clearInterval(interval); timerEl.textContent = 'Expired'; }
}, 1000);

function resendOtp() {
    window.location.href = 'forgot-password.jsp';
}
</script>
</body>
</html>