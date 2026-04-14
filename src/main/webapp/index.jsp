<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login — Elective Recommendation System</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;min-height:100vh;display:flex;background:#f0f2ff;overflow:hidden}

/* LEFT PANEL */
.left{width:52%;background:#534AB7;position:relative;display:flex;flex-direction:column;justify-content:center;align-items:flex-start;padding:60px 56px;overflow:hidden}

/* Decorative circles */
.left::before{content:'';position:absolute;width:420px;height:420px;border-radius:50%;border:1.5px solid rgba(255,255,255,.1);top:-100px;right:-120px}
.left::after{content:'';position:absolute;width:260px;height:260px;border-radius:50%;border:1.5px solid rgba(255,255,255,.08);bottom:-60px;left:-80px}
.circle-sm{position:absolute;width:140px;height:140px;border-radius:50%;border:1.5px solid rgba(255,255,255,.12);bottom:120px;right:60px}
.circle-xs{position:absolute;width:60px;height:60px;border-radius:50%;background:rgba(255,255,255,.06);top:180px;right:200px}
.dot-grid{position:absolute;bottom:40px;right:40px;display:grid;grid-template-columns:repeat(6,1fr);gap:8px;opacity:.18}
.dot-grid span{width:4px;height:4px;border-radius:50%;background:#fff;display:block}

/* Logo on left */
.logo{display:flex;align-items:center;gap:10px;margin-bottom:52px}
.logo-mark{width:38px;height:38px;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);border-radius:10px;display:flex;align-items:center;justify-content:center}
.logo-mark svg{width:18px;height:18px}
.logo-text{font-size:15px;font-weight:700;color:#fff;letter-spacing:.01em}
.logo-text span{opacity:.7}

.left-heading{font-size:38px;font-weight:800;color:#fff;line-height:1.18;letter-spacing:-.02em;margin-bottom:16px}
.left-heading em{font-style:normal;color:#AFA9EC}
.left-sub{font-size:14px;color:rgba(255,255,255,.65);line-height:1.7;max-width:340px;margin-bottom:40px}

/* Feature pills */
.features{display:flex;flex-direction:column;gap:12px}
.feat{display:flex;align-items:center;gap:12px}
.feat-icon{width:34px;height:34px;border-radius:9px;background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.18);display:flex;align-items:center;justify-content:center;flex-shrink:0}
.feat-icon svg{width:15px;height:15px}
.feat-text{font-size:13px;color:rgba(255,255,255,.8);font-weight:500}

/* Stats row */
.stats-row{display:flex;gap:28px;margin-top:44px;padding-top:32px;border-top:1px solid rgba(255,255,255,.12)}
.stat-item{display:flex;flex-direction:column;gap:3px}
.stat-val{font-size:22px;font-weight:800;color:#fff}
.stat-lbl{font-size:11px;color:rgba(255,255,255,.5);font-weight:500;letter-spacing:.04em;text-transform:uppercase}

/* RIGHT PANEL */
.right{flex:1;display:flex;justify-content:center;align-items:center;padding:40px 48px;background:#f0f2ff;position:relative}
.right::before{content:'';position:absolute;width:300px;height:300px;border-radius:50%;background:#EEEDFE;top:-80px;right:-80px;z-index:0}
.right::after{content:'';position:absolute;width:200px;height:200px;border-radius:50%;background:#e8e6fc;bottom:-60px;left:20px;z-index:0}

.card{background:#fff;border:1px solid #e8e8f0;border-radius:20px;padding:36px 38px;width:100%;max-width:400px;position:relative;z-index:1;box-shadow:0 8px 40px rgba(83,74,183,.08)}

/* Card top accent */
.card-accent{height:4px;background:#534AB7;border-radius:4px 4px 0 0;position:absolute;top:0;left:0;right:0}

.card-logo{display:flex;align-items:center;gap:8px;margin-bottom:28px}
.card-logo-mark{width:30px;height:30px;background:#534AB7;border-radius:8px;display:flex;align-items:center;justify-content:center}
.card-logo-mark svg{width:14px;height:14px}
.card-logo-text{font-size:13px;font-weight:700;color:#1a1a2e}
.card-logo-text span{color:#534AB7}

.card-title{font-size:22px;font-weight:800;color:#1a1a2e;margin-bottom:4px;letter-spacing:-.02em}
.card-sub{font-size:13px;color:#9ca3af;margin-bottom:28px}

/* Role tabs */
.role-tabs{display:flex;gap:6px;background:#f0f2ff;border-radius:10px;padding:4px;margin-bottom:22px}
.role-tab{flex:1;padding:9px;border:none;border-radius:7px;font-size:13px;font-weight:600;cursor:pointer;background:transparent;color:#6b7280;transition:all .15s;display:flex;align-items:center;justify-content:center;gap:6px}
.role-tab svg{width:13px;height:13px}
.role-tab.active{background:#fff;color:#534AB7;box-shadow:0 1px 6px rgba(83,74,183,.12)}

/* Fields */
.field{display:flex;flex-direction:column;gap:5px;margin-bottom:14px}
.field label{font-size:11px;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.05em}
.input-wrap{position:relative}
.input-wrap svg{position:absolute;left:12px;top:50%;transform:translateY(-50%);width:14px;height:14px;color:#9ca3af;pointer-events:none}
.field input{width:100%;padding:10px 12px 10px 36px;border:1.5px solid #e0e0f0;border-radius:9px;font-size:13px;color:#1a1a2e;background:#fafafa;outline:none;font-family:inherit;transition:border-color .15s,box-shadow .15s}
.field input:focus{border-color:#534AB7;background:#fff;box-shadow:0 0 0 3px #EEEDFE}

/* Slide panels */
.slide-panel{display:none}
.slide-panel.active{display:block}

/* Error */
.error-box{display:flex;align-items:center;gap:8px;background:#FEE2E2;border:1px solid #FECACA;border-radius:9px;padding:10px 14px;margin-bottom:16px;font-size:13px;color:#991B1B}
.error-box svg{width:14px;height:14px;flex-shrink:0}

/* Submit button */
.btn-submit{width:100%;padding:11px;background:#534AB7;color:#fff;border:none;border-radius:9px;font-size:14px;font-weight:700;cursor:pointer;transition:background .15s,transform .1s;margin-top:6px;letter-spacing:.01em}
.btn-submit:hover{background:#3C3489}
.btn-submit:active{transform:scale(.99)}

/* Register link */
.register-row{text-align:center;margin-top:20px;font-size:13px;color:#9ca3af}
.register-row a{color:#534AB7;font-weight:600;text-decoration:none}
.register-row a:hover{text-decoration:underline}

/* Divider */
.divider{display:flex;align-items:center;gap:10px;margin:16px 0}
.divider span{flex:1;height:1px;background:#e8e8f0}
.divider p{font-size:11px;color:#c0c0d0;font-weight:500}
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
        Pick the right<br>elective, shape your<br><em>future.</em>
    </div>
    <div class="left-sub">
        A smart system that matches your academic profile with the best-fit electives — powered by your CGPA, interests, and career goals.
    </div>

<!--    <div class="features">
        <div class="feat">
            <div class="feat-icon">
                <svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="white" stroke-width="1.2" fill="none" stroke-linejoin="round"/></svg>
            </div>
            <span class="feat-text">AI-powered elective recommendations</span>
        </div>-->
        <div class="feat">
            <div class="feat-icon">
                <svg viewBox="0 0 16 16" fill="none"><path d="M2 12L5 8L8 10L11 5L14 7" stroke="white" stroke-width="1.3" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
            </div>
            <span class="feat-text">Track your CGPA and academic growth</span>
        </div>
        <div class="feat">
            <div class="feat-icon">
                <svg viewBox="0 0 16 16" fill="none"><path d="M3 3h10a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" stroke="white" stroke-width="1.2" fill="none"/></svg>
            </div>
            <span class="feat-text">Direct chat support with admin</span>
        </div>
    </div>

<!--    <div class="stats-row">
        <div class="stat-item">
            <span class="stat-val">50+</span>
            <span class="stat-lbl">Electives</span>
        </div>
        <div class="stat-item">
            <span class="stat-val">500+</span>
            <span class="stat-lbl">Students</span>
        </div>
        <div class="stat-item">
            <span class="stat-val">98%</span>
            <span class="stat-lbl">Satisfaction</span>
        </div>
    </div>-->
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

        <div class="card-title">Welcome back</div>
        <div class="card-sub">Sign in to continue to your dashboard</div>

        <!-- Error message -->
        <%
            String error = (String) request.getAttribute("error");
            if(error != null){
        %>
        <div class="error-box">
            <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" stroke="#991B1B" stroke-width="1.4"/><path d="M8 5v3M8 10.5v.5" stroke="#991B1B" stroke-width="1.5" stroke-linecap="round"/></svg>
            <%= error %>
        </div>
        <% } %>

        <!-- Role Tabs -->
        <div class="role-tabs">
            <button type="button" class="role-tab active" id="tab-student" onclick="switchRole('student')">
                <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5.5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M3 14c0-2.76 2.24-5 5-5s5 2.24 5 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                Student
            </button>
            <button type="button" class="role-tab" id="tab-admin" onclick="switchRole('admin')">
                <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="7" width="12" height="7" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7V5a3 3 0 0 1 6 0v2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                Admin
            </button>
        </div>

        <form action="login" method="post" id="loginForm">
            <input type="hidden" name="role" id="roleInput" value="student">

            <!-- STUDENT FIELDS -->
            <div class="slide-panel active" id="panel-student">
                <div class="field">
                    <label>Student ID</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="2" width="10" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><path d="M5 6h6M5 9h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
                        <input type="text" name="studentId" placeholder="Enter your student ID">
                    </div>
                </div>
            </div>

            <!-- ADMIN FIELDS -->
            <div class="slide-panel" id="panel-admin">
                <div class="field">
                    <label>Username</label>
                    <div class="input-wrap">
                        <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5.5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M3 14c0-2.76 2.24-5 5-5s5 2.24 5 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                        <input type="text" name="username" placeholder="Enter admin username">
                    </div>
                </div>
            </div>

            <!-- PASSWORD -->
            <div class="field">
                <label>Password</label>
                <div class="input-wrap">
                    <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7V5a3 3 0 0 1 6 0v2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <div class="divider"><span></span><p>New to the system?</p><span></span></div>

        <div class="register-row">
            Don't have an account?
            <a href="<%= request.getContextPath() %>/register.jsp">Create one</a>
        </div>
    </div>
</div>

<script>
function switchRole(role) {
    document.getElementById('roleInput').value = role;
    document.querySelectorAll('.role-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.slide-panel').forEach(p => p.classList.remove('active'));
    document.getElementById('tab-' + role).classList.add('active');
    document.getElementById('panel-' + role).classList.add('active');
}

// Auto-select role if error on page reload
<% if(error != null) { %>
    const savedRole = '<%= request.getParameter("role") != null ? request.getParameter("role") : "student" %>';
    if(savedRole) switchRole(savedRole);
<% } %>
</script>
</body>
</html>