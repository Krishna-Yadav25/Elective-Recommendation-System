<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register — Elective Recommendation System</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;min-height:100vh;display:flex;background:#f0f2ff;overflow:hidden}

/* LEFT PANEL */
.left{width:52%;background:#534AB7;position:relative;display:flex;flex-direction:column;justify-content:center;align-items:flex-start;padding:60px 56px;overflow:hidden}
.left::before{content:'';position:absolute;width:420px;height:420px;border-radius:50%;border:1.5px solid rgba(255,255,255,.1);top:-100px;right:-120px}
.left::after{content:'';position:absolute;width:260px;height:260px;border-radius:50%;border:1.5px solid rgba(255,255,255,.08);bottom:-60px;left:-80px}
.circle-sm{position:absolute;width:140px;height:140px;border-radius:50%;border:1.5px solid rgba(255,255,255,.12);bottom:120px;right:60px}
.circle-xs{position:absolute;width:60px;height:60px;border-radius:50%;background:rgba(255,255,255,.06);top:180px;right:200px}
.dot-grid{position:absolute;bottom:40px;right:40px;display:grid;grid-template-columns:repeat(6,1fr);gap:8px;opacity:.18}
.dot-grid span{width:4px;height:4px;border-radius:50%;background:#fff;display:block}

.logo{display:flex;align-items:center;gap:10px;margin-bottom:52px}
.logo-mark{width:38px;height:38px;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);border-radius:10px;display:flex;align-items:center;justify-content:center}
.logo-mark svg{width:18px;height:18px}
.logo-text{font-size:15px;font-weight:700;color:#fff;letter-spacing:.01em}
.logo-text span{opacity:.7}

.left-heading{font-size:38px;font-weight:800;color:#fff;line-height:1.18;letter-spacing:-.02em;margin-bottom:16px}
.left-heading em{font-style:normal;color:#AFA9EC}
.left-sub{font-size:14px;color:rgba(255,255,255,.65);line-height:1.7;max-width:340px;margin-bottom:40px}

.steps{display:flex;flex-direction:column;gap:16px}
.step{display:flex;align-items:flex-start;gap:14px}
.step-num{width:28px;height:28px;border-radius:8px;background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:#fff;flex-shrink:0;margin-top:1px}
.step-info{}
.step-title{font-size:13px;font-weight:700;color:#fff;margin-bottom:2px}
.step-desc{font-size:12px;color:rgba(255,255,255,.55);line-height:1.5}

.left-badge{display:inline-flex;align-items:center;gap:6px;margin-top:40px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.18);border-radius:20px;padding:7px 14px;font-size:12px;color:rgba(255,255,255,.75);font-weight:500}
.left-badge-dot{width:6px;height:6px;border-radius:50%;background:#4ade80}

/* RIGHT PANEL */
.right{flex:1;display:flex;justify-content:center;align-items:center;padding:32px 48px;background:#f0f2ff;position:relative;overflow-y:auto}
.right::before{content:'';position:absolute;width:300px;height:300px;border-radius:50%;background:#EEEDFE;top:-80px;right:-80px;z-index:0}
.right::after{content:'';position:absolute;width:200px;height:200px;border-radius:50%;background:#e8e6fc;bottom:-60px;left:20px;z-index:0}

.card{background:#fff;border:1px solid #e8e8f0;border-radius:20px;padding:32px 36px;width:100%;max-width:400px;position:relative;z-index:1;box-shadow:0 8px 40px rgba(83,74,183,.08)}
.card-accent{height:4px;background:#534AB7;border-radius:4px 4px 0 0;position:absolute;top:0;left:0;right:0}

.card-logo{display:flex;align-items:center;gap:8px;margin-bottom:24px}
.card-logo-mark{width:30px;height:30px;background:#534AB7;border-radius:8px;display:flex;align-items:center;justify-content:center}
.card-logo-mark svg{width:14px;height:14px}
.card-logo-text{font-size:13px;font-weight:700;color:#1a1a2e}
.card-logo-text span{color:#534AB7}

.card-title{font-size:22px;font-weight:800;color:#1a1a2e;margin-bottom:4px;letter-spacing:-.02em}
.card-sub{font-size:13px;color:#9ca3af;margin-bottom:24px}

/* Fields */
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.field{display:flex;flex-direction:column;gap:5px}
.field.full{grid-column:span 2}
.field label{font-size:11px;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.05em}
.input-wrap{position:relative}
.input-wrap svg{position:absolute;left:11px;top:50%;transform:translateY(-50%);width:14px;height:14px;color:#9ca3af;pointer-events:none}
.field input{width:100%;padding:10px 12px 10px 34px;border:1.5px solid #e0e0f0;border-radius:9px;font-size:13px;color:#1a1a2e;background:#fafafa;outline:none;font-family:inherit;transition:border-color .15s,box-shadow .15s}
.field input:focus{border-color:#534AB7;background:#fff;box-shadow:0 0 0 3px #EEEDFE}
.field input.error{border-color:#ef4444;box-shadow:0 0 0 3px #FEE2E2}

/* Password strength */
.pwd-strength{height:3px;border-radius:3px;margin-top:5px;background:#e8e8f0;overflow:hidden}
.pwd-fill{height:100%;border-radius:3px;width:0%;transition:width .3s,background .3s}
.pwd-hint{font-size:11px;color:#9ca3af;margin-top:3px}

/* Error box */
.error-box{display:flex;align-items:center;gap:8px;background:#FEE2E2;border:1px solid #FECACA;border-radius:9px;padding:10px 14px;margin-bottom:14px;font-size:13px;color:#991B1B}
.error-box svg{width:14px;height:14px;flex-shrink:0}

/* Inline field error */
.field-error{font-size:11px;color:#ef4444;margin-top:3px;display:none}
.field-error.show{display:block}

.btn-submit{width:100%;padding:11px;background:#534AB7;color:#fff;border:none;border-radius:9px;font-size:14px;font-weight:700;cursor:pointer;transition:background .15s,transform .1s;margin-top:14px;letter-spacing:.01em}
.btn-submit:hover{background:#3C3489}
.btn-submit:active{transform:scale(.99)}

.divider{display:flex;align-items:center;gap:10px;margin:16px 0 0}
.divider span{flex:1;height:1px;background:#e8e8f0}
.divider p{font-size:11px;color:#c0c0d0;font-weight:500}
.login-row{text-align:center;margin-top:14px;font-size:13px;color:#9ca3af}
.login-row a{color:#534AB7;font-weight:600;text-decoration:none}
.login-row a:hover{text-decoration:underline}
</style>
</head>
<body>

<!-- LEFT PANEL -->
<div class="left">
    <div class="circle-sm"></div>
    <div class="circle-xs"></div>
    <div class="dot-grid">
        <% for(int i=0;i<30;i++){ %><span></span><% } %>
    </div>

    <div class="logo">
        <div class="logo-mark">
            <svg viewBox="0 0 16 16" fill="none">
                <rect x="2" y="2" width="5" height="5" rx="1.5" fill="white"/>
                <rect x="9" y="2" width="5" height="5" rx="1.5" fill="white" opacity=".5"/>
                <rect x="2" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".5"/>
                <rect x="9" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".75"/>
            </svg>
        </div>
        <span class="logo-text">Elective <span>Recommendation</span> System</span>
    </div>

    <div class="left-heading">
        Start your<br>academic journey<br><em>the smart way.</em>
    </div>
    <div class="left-sub">
        Create your account in seconds and get personalized elective recommendations based on your profile, interests, and career goals.
    </div>

    <div class="steps">
        <div class="step">
            <div class="step-num">1</div>
            <div class="step-info">
                <div class="step-title">Create your account</div>
                <div class="step-desc">Register with your student ID and set a secure password</div>
            </div>
        </div>
        <div class="step">
            <div class="step-num">2</div>
            <div class="step-info">
                <div class="step-title">Fill your academic profile</div>
                <div class="step-desc">Add your CGPA, branch, semester and career goal</div>
            </div>
        </div>
        <div class="step">
            <div class="step-num">3</div>
            <div class="step-info">
                <div class="step-title">Get recommendations</div>
                <div class="step-desc">Receive tailored elective suggestions instantly</div>
            </div>
        </div>
    </div>

    <div class="left-badge">
        <span class="left-badge-dot"></span>
        Free for all enrolled students
    </div>
</div>

<!-- RIGHT PANEL -->
<div class="right">
    <div class="card">
        <div class="card-accent"></div>

        <div class="card-logo">
            <div class="card-logo-mark">
                <svg viewBox="0 0 16 16" fill="none">
                    <rect x="2" y="2" width="5" height="5" rx="1.5" fill="white"/>
                    <rect x="9" y="2" width="5" height="5" rx="1.5" fill="white" opacity=".5"/>
                    <rect x="2" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".5"/>
                    <rect x="9" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".75"/>
                </svg>
            </div>
            <span class="card-logo-text">Elective <span>System</span></span>
        </div>

        <div class="card-title">Create account</div>
        <div class="card-sub">Fill in your details to get started</div>

        <%
            String error = (String) request.getAttribute("error");
            if(error != null){
        %>
        <div class="error-box">
            <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" stroke="#991B1B" stroke-width="1.4"/><path d="M8 5v3M8 10.5v.5" stroke="#991B1B" stroke-width="1.5" stroke-linecap="round"/></svg>
            <%= error %>
        </div>
        <% } %>

        <form action="register" method="post" onsubmit="return validate()" id="regForm">
            <div class="form-grid">

                <!-- FULL NAME -->
                <div class="field full">
                    <label>Full Name</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5.5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M3 14c0-2.76 2.24-5 5-5s5 2.24 5 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                        <input type="text" name="name" id="fname" placeholder="Enter your full name" required>
                    </div>
                    <span class="field-error" id="err-name">Name cannot be empty</span>
                </div>

                <!-- STUDENT ID -->
                <div class="field full">
                    <label>Student ID</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="2" width="10" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><path d="M5 6h6M5 9h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
                        <input type="text" name="studentId" id="fstid" placeholder="e.g. 22CS001" required>
                    </div>
                </div>

                <!-- ✅ EMAIL — NEW FIELD -->
                <div class="field full">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="9" rx="1.5" stroke="currentColor" stroke-width="1.3"/><path d="M2 5l6 5 6-5" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
                        <input type="email" name="email" id="femail" placeholder="Enter your email address" required>
                    </div>
                    <span class="field-error" id="err-email">Please enter a valid email</span>
                </div>

                <!-- PASSWORD -->
                <div class="field">
                    <label>Password</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7V5a3 3 0 0 1 6 0v2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                        <input type="password" name="password" id="fpwd" placeholder="Min 6 characters" required oninput="checkStrength(this.value)">
                    </div>
                    <div class="pwd-strength"><div class="pwd-fill" id="pwdFill"></div></div>
                    <span class="pwd-hint" id="pwdHint">Enter a password</span>
                    <span class="field-error" id="err-pwd">Minimum 6 characters required</span>
                </div>

                <!-- CONFIRM PASSWORD -->
                <div class="field">
                    <label>Confirm Password</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7V5a3 3 0 0 1 6 0v2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                        <input type="password" name="confirm" id="fconf" placeholder="Re-enter password" required>
                    </div>
                    <span class="field-error" id="err-conf">Passwords do not match</span>
                </div>

            </div>

            <button type="submit" class="btn-submit">Create Account</button>
        </form>

        <div class="divider"><span></span><p>Already registered?</p><span></span></div>
        <div class="login-row">
            Have an account? <a href="index.jsp">Sign in</a>
        </div>
    </div>
</div>

<script>
function checkStrength(val) {
    const fill = document.getElementById('pwdFill');
    const hint = document.getElementById('pwdHint');
    if (val.length === 0) { fill.style.width='0%'; hint.textContent='Enter a password'; return; }
    if (val.length < 4)   { fill.style.width='25%'; fill.style.background='#ef4444'; hint.textContent='Too short'; return; }
    if (val.length < 6)   { fill.style.width='50%'; fill.style.background='#f97316'; hint.textContent='Weak'; return; }
    const strong = /[A-Z]/.test(val) && /[0-9]/.test(val) && /[^A-Za-z0-9]/.test(val);
    const medium = /[A-Z]/.test(val) || /[0-9]/.test(val);
    if (strong)      { fill.style.width='100%'; fill.style.background='#1D9E75'; hint.textContent='Strong password'; }
    else if (medium) { fill.style.width='70%';  fill.style.background='#BA7517'; hint.textContent='Medium — add numbers or symbols'; }
    else             { fill.style.width='55%';  fill.style.background='#f97316'; hint.textContent='Weak — try mixing cases'; }
}

function showErr(id, inputId) {
    document.getElementById(id).classList.add('show');
    if(inputId) document.getElementById(inputId).classList.add('error');
}
function clearErr(id, inputId) {
    document.getElementById(id).classList.remove('show');
    if(inputId) document.getElementById(inputId).classList.remove('error');
}

function validate() {
    let ok = true;
    const name  = document.getElementById('fname').value.trim();
    const email = document.getElementById('femail').value.trim();
    const pwd   = document.getElementById('fpwd').value;
    const conf  = document.getElementById('fconf').value;

    clearErr('err-name','fname');
    clearErr('err-email','femail');
    clearErr('err-pwd','fpwd');
    clearErr('err-conf','fconf');

    if (name === '')  { showErr('err-name','fname');   ok = false; }
    if (email === '') { showErr('err-email','femail'); ok = false; }
    if (pwd.length < 6) { showErr('err-pwd','fpwd');  ok = false; }
    if (pwd !== conf)   { showErr('err-conf','fconf'); ok = false; }
    return ok;
}
</script>
</body>
</html>