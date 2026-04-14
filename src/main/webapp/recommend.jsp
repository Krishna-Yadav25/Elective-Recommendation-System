<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    String name = (String) session.getAttribute("name");
    if (name == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String initials = name.length() >= 2
        ? name.substring(0,2).toUpperCase()
        : name.substring(0,1).toUpperCase();

    List<String> recs = (List<String>) request.getAttribute("recommendations");
    int total = (recs != null) ? recs.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Recommended Electives — Elective System</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f0f2ff;color:#1a1a2e;min-height:100vh}

/* Topbar */
.topbar{background:#fff;border-bottom:1px solid #e8e8f0;padding:0 28px;height:58px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100}
.logo{display:flex;align-items:center;gap:10px}
.logo-mark{width:32px;height:32px;background:#534AB7;border-radius:8px;display:flex;align-items:center;justify-content:center}
.logo-mark svg{width:16px;height:16px}
.logo-text{font-size:15px;font-weight:700;color:#1a1a2e}
.logo-text span{color:#534AB7}
.topbar-right{display:flex;align-items:center;gap:10px}
.user-chip{display:flex;align-items:center;gap:8px;padding:5px 14px 5px 5px;border:1px solid #e0e0f0;border-radius:30px;background:#f7f7ff;font-size:13px;font-weight:500}
.av{width:28px;height:28px;border-radius:50%;background:#534AB7;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#fff}
.btn-back{padding:7px 16px;border-radius:8px;border:1.5px solid #AFA9EC;background:#EEEDFE;color:#534AB7;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px}
.btn-back:hover{background:#534AB7;color:#fff;border-color:#534AB7}
.btn-back svg{width:13px;height:13px}

/* Page body */
.page{max-width:780px;margin:0 auto;padding:28px 22px}

/* Top info bar */
.info-bar{background:#fff;border:1px solid #e8e8f0;border-radius:14px;padding:16px 22px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:20px}
.info-bar-left{display:flex;align-items:center;gap:12px}
.info-icon{width:42px;height:42px;border-radius:11px;background:#EEEDFE;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.info-icon svg{width:20px;height:20px}
.info-title{font-size:16px;font-weight:800;color:#1a1a2e;letter-spacing:-.01em}
.info-sub{font-size:12px;color:#6b7280;margin-top:2px}
.count-badge{display:flex;align-items:center;gap:6px;background:#EEEDFE;border:1px solid #AFA9EC;border-radius:20px;padding:6px 14px;font-size:13px;font-weight:700;color:#534AB7}
.count-badge svg{width:13px;height:13px}

/* Elective cards */
.cards-list{display:flex;flex-direction:column;gap:10px}

.rec-card{background:#fff;border:1px solid #e8e8f0;border-radius:12px;padding:16px 18px;display:flex;align-items:center;gap:16px;transition:box-shadow .15s,border-color .15s;position:relative;overflow:hidden}
.rec-card::before{content:'';position:absolute;left:0;top:0;bottom:0;width:4px;background:#534AB7;border-radius:4px 0 0 4px}
.rec-card:hover{box-shadow:0 4px 20px rgba(83,74,183,.1);border-color:#AFA9EC}

.rec-card.domain-ai::before{background:#534AB7}
.rec-card.domain-web::before{background:#1D9E75}
.rec-card.domain-cyber::before{background:#BA7517}
.rec-card.domain-data::before{background:#185FA5}
.rec-card.domain-general::before{background:#888780}

.rank-badge{width:32px;height:32px;border-radius:9px;background:#EEEDFE;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:800;color:#534AB7;flex-shrink:0}
.rec-card.domain-web .rank-badge{background:#E1F5EE;color:#0F6E56}
.rec-card.domain-cyber .rank-badge{background:#FAEEDA;color:#633806}
.rec-card.domain-data .rank-badge{background:#E6F1FB;color:#0C447C}
.rec-card.domain-general .rank-badge{background:#F1EFE8;color:#5F5E5A}

.rec-info{flex:1}
.rec-name{font-size:14px;font-weight:700;color:#1a1a2e}
.rec-domain{font-size:12px;color:#6b7280;margin-top:3px;display:flex;align-items:center;gap:5px}
.rec-domain svg{width:11px;height:11px}

.domain-tag{display:inline-block;font-size:11px;font-weight:600;padding:2px 9px;border-radius:20px;margin-left:6px}
.tag-ai{background:#EEEDFE;color:#3C3489}
.tag-web{background:#E1F5EE;color:#085041}
.tag-cyber{background:#FAEEDA;color:#633806}
.tag-data{background:#E6F1FB;color:#0C447C}
.tag-general{background:#F1EFE8;color:#5F5E5A}

.btn-select{padding:8px 18px;background:#534AB7;color:#fff;border:none;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;transition:background .15s,transform .1s;flex-shrink:0}
.btn-select:hover{background:#3C3489}
.btn-select:active{transform:scale(.97)}
.btn-select.selected{background:#1D9E75}

/* Empty state */
.empty{background:#fff;border:1px solid #e8e8f0;border-radius:14px;padding:48px 22px;text-align:center}
.empty-icon{width:56px;height:56px;background:#EEEDFE;border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 14px}
.empty-icon svg{width:26px;height:26px}
.empty-title{font-size:15px;font-weight:700;color:#1a1a2e;margin-bottom:6px}
.empty-sub{font-size:13px;color:#9ca3af}

/* Bottom bar */
.bottom-bar{background:#fff;border:1px solid #e8e8f0;border-radius:14px;padding:16px 22px;display:flex;align-items:center;justify-content:space-between;margin-top:20px;flex-wrap:wrap;gap:10px}
.hint{font-size:12px;color:#9ca3af}
.btn-dashboard{padding:10px 22px;background:#534AB7;color:#fff;border:none;border-radius:9px;font-size:13px;font-weight:700;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:7px}
.btn-dashboard:hover{background:#3C3489}
.btn-dashboard svg{width:13px;height:13px}
</style>
</head>
<body>

<!-- TOPBAR -->
<div class="topbar">
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
    <div class="topbar-right">
        <div class="user-chip">
            <div class="av"><%= initials %></div>
            <%= name %>
        </div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn-back">
            <svg viewBox="0 0 16 16" fill="none"><path d="M10 3L5 8l5 5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Dashboard
        </a>
    </div>
</div>

<!-- PAGE -->
<div class="page">

    <!-- Info bar -->
    <div class="info-bar">
        <div class="info-bar-left">
            <div class="info-icon">
                <svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="#534AB7" stroke-width="1.3" fill="none" stroke-linejoin="round"/></svg>
            </div>
            <div>
                <div class="info-title">Recommended Electives</div>
                <div class="info-sub">Based on your interest and CGPA — select one to enroll</div>
            </div>
        </div>
        <div class="count-badge">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="9" rx="1.5" stroke="#534AB7" stroke-width="1.3" fill="none"/><path d="M5 4V3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1" stroke="#534AB7" stroke-width="1.3"/></svg>
            <%= total %> Recommendations
        </div>
    </div>

    <!-- Cards -->
    <% if (recs != null && !recs.isEmpty()) { %>
    <div class="cards-list">
    <%
        int idx = 1;
        for (String r : recs) {
            String domain = "General";
            String domainClass = "domain-general";
            String tagClass = "tag-general";
            String rLow = r.toLowerCase();
            if(rLow.contains("machine") || rLow.contains("ai") || rLow.contains("deep learning") || rLow.contains("neural") || rLow.contains("vision")) {
                domain = "AI / ML"; domainClass = "domain-ai"; tagClass = "tag-ai";
            } else if(rLow.contains("web") || rLow.contains("devops") || rLow.contains("cloud") || rLow.contains("react") || rLow.contains("node")) {
                domain = "Web Development"; domainClass = "domain-web"; tagClass = "tag-web";
            } else if(rLow.contains("cyber") || rLow.contains("security") || rLow.contains("network") || rLow.contains("ethical")) {
                domain = "Cyber Security"; domainClass = "domain-cyber"; tagClass = "tag-cyber";
            } else if(rLow.contains("data") || rLow.contains("analytics") || rLow.contains("statistics") || rLow.contains("mining")) {
                domain = "Data Science"; domainClass = "domain-data"; tagClass = "tag-data";
            }
    %>
        <div class="rec-card <%= domainClass %>">
            <div class="rank-badge"><%= idx %></div>
            <div class="rec-info">
                <div class="rec-name"><%= r %></div>
                <div class="rec-domain">
                    <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="9" rx="1.5" stroke="currentColor" stroke-width="1.2" fill="none"/><path d="M5 4V3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1" stroke="currentColor" stroke-width="1.2"/></svg>
                    <%= domain %>
                    <span class="domain-tag <%= tagClass %>"><%= domain %></span>
                </div>
            </div>
            <form action="selectElective" method="post">
                <input type="hidden" name="name" value="<%= r %>">
                <input type="hidden" name="domain" value="<%= domain %>">
                <button type="submit" class="btn-select" onclick="markSelected(this)">Select</button>
            </form>
        </div>
    <% idx++; } %>
    </div>
    <% } else { %>
    <div class="empty">
        <div class="empty-icon">
            <svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="#AFA9EC" stroke-width="1.3" fill="none" stroke-linejoin="round"/></svg>
        </div>
        <div class="empty-title">No recommendations found</div>
        <div class="empty-sub">Try changing your interest area or CGPA and submit again from the dashboard.</div>
    </div>
    <% } %>

    <!-- Bottom bar -->
    <div class="bottom-bar">
        <span class="hint">Select an elective to add it to your enrolled list</span>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn-dashboard">
            <svg viewBox="0 0 16 16" fill="none"><path d="M10 3L5 8l5 5" stroke="white" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Back to Dashboard
        </a>
    </div>

</div>

<script>
function markSelected(btn) {
    btn.textContent = 'Selected ✓';
    btn.classList.add('selected');
    btn.disabled = true;
}
</script>
</body>
</html>
