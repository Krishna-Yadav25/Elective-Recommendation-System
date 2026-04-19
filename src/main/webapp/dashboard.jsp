<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="static com.mongodb.client.model.Filters.eq" %>
<%@ page import="static com.mongodb.client.model.Filters.and" %>
<%
    String name      = (String) session.getAttribute("name");
    String studentId = (String) session.getAttribute("studentId");
    String role      = (String) session.getAttribute("role");

    if (name == null) { response.sendRedirect("index.jsp"); return; }

    String initials = name.length() >= 2
        ? name.substring(0,2).toUpperCase()
        : name.substring(0,1).toUpperCase();

    String fBranch      = request.getAttribute("branch")      != null ? (String)request.getAttribute("branch")      : "";
    String fSemester    = request.getAttribute("semester")    != null ? (String)request.getAttribute("semester")    : "";
    String fTenth       = request.getAttribute("tenth")       != null ? (String)request.getAttribute("tenth")       : "";
    String fTwelfth     = request.getAttribute("twelfth")     != null ? (String)request.getAttribute("twelfth")     : "";
    String fCgpa        = request.getAttribute("cgpa")        != null ? (String)request.getAttribute("cgpa")        : "";
    String fCodingLevel = request.getAttribute("codingLevel") != null ? (String)request.getAttribute("codingLevel") : "";
    String fGoal        = request.getAttribute("goal")        != null ? (String)request.getAttribute("goal")        : "";
    String fStream      = request.getAttribute("stream")      != null ? (String)request.getAttribute("stream")      : "";

    String statCgpa   = fCgpa.isEmpty()        ? (session.getAttribute("cgpa")        != null ? (String)session.getAttribute("cgpa")        : "—") : fCgpa;
    String statTenth  = fTenth.isEmpty()       ? "—" : fTenth;
    String statCoding = fCodingLevel.isEmpty() ? (session.getAttribute("codingLevel") != null ? (String)session.getAttribute("codingLevel") : "—") : fCodingLevel;
    String statGoal   = fGoal.isEmpty()        ? (session.getAttribute("goal")        != null ? (String)session.getAttribute("goal")        : "—") : fGoal;
    String statBranch = fBranch.isEmpty()      ? (session.getAttribute("branch")      != null ? (String)session.getAttribute("branch")      : "CSE") : fBranch;
    String statSem    = fSemester.isEmpty()    ? (session.getAttribute("semester")    != null ? (String)session.getAttribute("semester")    : "—") : fSemester;

    String photo      = (String) session.getAttribute("photo");
    boolean justSaved = "true".equals(request.getParameter("saved"));
    boolean hasError  = "true".equals(request.getParameter("error"));
    String  openSec   = request.getParameter("section") != null ? request.getParameter("section") : "academic";

    /* ── Fetch unread notification count ── */
    int unreadCount = 0;
    List<Document> notifList = new ArrayList<>();
    try {
        com.mongodb.client.MongoClient nClient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
        com.mongodb.client.MongoCollection<Document> nCol =
            nClient.getDatabase("electiveDB").getCollection("notifications");
        notifList = nCol.find(eq("studentId", studentId))
                        .sort(new Document("_id", -1))
                        .limit(20)
                        .into(new ArrayList<>());
        for (Document nd : notifList) {
            if (!Boolean.TRUE.equals(nd.getBoolean("read"))) unreadCount++;
        }
        nClient.close();
    } catch (Exception ex) { /* ignore */ }

    /* ── Fetch active announcements ── */
    List<Document> announcements = new ArrayList<>();
    try {
        com.mongodb.client.MongoClient aClient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
        com.mongodb.client.MongoCollection<Document> aCol =
            aClient.getDatabase("electiveDB").getCollection("announcements");
        announcements = aCol.find(eq("active", true))
                            .sort(new Document("_id", -1))
                            .limit(10)
                            .into(new ArrayList<>());
        aClient.close();
    } catch (Exception ex) { /* ignore */ }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard — Elective Recommendation System</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f0f2ff;color:#1a1a2e;min-height:100vh}

.topbar{background:#fff;border-bottom:1px solid #e8e8f0;padding:0 28px;height:58px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:200}
.logo{display:flex;align-items:center;gap:10px}
.logo-mark{width:32px;height:32px;background:#534AB7;border-radius:8px;display:flex;align-items:center;justify-content:center}
.logo-mark svg{width:16px;height:16px}
.logo-text{font-size:15px;font-weight:700;color:#1a1a2e}
.logo-text span{color:#534AB7}
.topbar-right{display:flex;align-items:center;gap:10px}
.user-chip{display:flex;align-items:center;gap:8px;padding:5px 14px 5px 5px;border:1px solid #e0e0f0;border-radius:30px;background:#f7f7ff;font-size:13px;font-weight:500}
.av{width:28px;height:28px;border-radius:50%;background:#534AB7;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#fff}
.btn-logout{padding:7px 16px;border-radius:8px;border:none;background:#ef4444;color:#fff;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-block}
.btn-logout:hover{background:#dc2626}

/* ── NOTIFICATION BELL ── */
.bell-wrap{position:relative;cursor:pointer}
.bell-btn{width:36px;height:36px;border-radius:9px;border:1px solid #e0e0f0;background:#f7f7ff;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:background .12s}
.bell-btn:hover{background:#EEEDFE;border-color:#AFA9EC}
.bell-btn svg{width:16px;height:16px;color:#6b7280}
.bell-dot{position:absolute;top:4px;right:4px;width:8px;height:8px;border-radius:50%;background:#ef4444;border:1.5px solid #fff;display:none}
.bell-dot.show{display:block}
.notif-badge{position:absolute;top:3px;right:3px;background:#ef4444;color:#fff;font-size:9px;font-weight:700;border-radius:10px;padding:0 4px;min-width:15px;height:15px;display:none;align-items:center;justify-content:center;border:1.5px solid #fff}
.notif-badge.show{display:flex}

/* ── NOTIFICATION DROPDOWN ── */
.notif-dropdown{position:absolute;top:calc(100% + 8px);right:0;width:320px;background:#fff;border:1px solid #e8e8f0;border-radius:14px;box-shadow:0 8px 32px rgba(83,74,183,.12);z-index:500;display:none;overflow:hidden}
.notif-dropdown.open{display:block}
.notif-drop-head{padding:14px 16px;border-bottom:1px solid #e8e8f0;display:flex;align-items:center;justify-content:space-between}
.notif-drop-title{font-size:13px;font-weight:700;color:#1a1a2e}
.mark-all-btn{font-size:11px;color:#534AB7;font-weight:600;cursor:pointer;border:none;background:none;padding:0}
.mark-all-btn:hover{text-decoration:underline}
.notif-list{max-height:300px;overflow-y:auto}
.notif-item{padding:12px 16px;border-bottom:1px solid #f5f5fa;display:flex;gap:10px;align-items:flex-start;cursor:pointer;transition:background .1s}
.notif-item:last-child{border-bottom:none}
.notif-item:hover{background:#faf9ff}
.notif-item.unread{background:#faf9ff}
.notif-icon{width:30px;height:30px;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.notif-icon svg{width:13px;height:13px}
.notif-text{flex:1}
.notif-msg{font-size:12px;color:#1a1a2e;line-height:1.5}
.notif-time{font-size:11px;color:#9ca3af;margin-top:2px}
.unread-dot{width:6px;height:6px;border-radius:50%;background:#534AB7;margin-top:5px;flex-shrink:0}
.notif-empty{padding:28px;text-align:center;font-size:13px;color:#9ca3af}
.notif-drop-foot{padding:10px 16px;border-top:1px solid #e8e8f0;text-align:center}
.notif-drop-foot a{font-size:12px;color:#534AB7;font-weight:600;cursor:pointer;text-decoration:none}
.notif-drop-foot a:hover{text-decoration:underline}

.layout{display:flex;min-height:calc(100vh - 58px)}
.sidebar{width:215px;flex-shrink:0;background:#fff;border-right:1px solid #e8e8f0;padding:16px 0;display:flex;flex-direction:column;position:sticky;top:58px;height:calc(100vh - 58px);overflow-y:auto}
.sidebar-label{padding:10px 16px 4px;font-size:10px;font-weight:700;color:#9ca3af;letter-spacing:.06em;text-transform:uppercase}
.nav-item{display:flex;align-items:center;gap:9px;padding:9px 16px;font-size:13px;color:#6b7280;cursor:pointer;border-left:2.5px solid transparent;transition:all .12s;user-select:none}
.nav-item:hover{background:#f5f3ff;color:#534AB7}
.nav-item.active{color:#534AB7;background:#EEEDFE;border-left-color:#534AB7;font-weight:600}
.nav-item svg{width:15px;height:15px;flex-shrink:0}
.nav-notif-dot{width:7px;height:7px;border-radius:50%;background:#ef4444;margin-left:auto;display:none;flex-shrink:0}
.nav-notif-dot.show{display:block}

.content{flex:1;padding:22px;display:flex;flex-direction:column;gap:18px}

/* ── ANNOUNCEMENT BANNER ── */
.ann-feed{display:flex;flex-direction:column;gap:8px}
.ann-banner{border-radius:11px;padding:13px 16px;display:flex;align-items:flex-start;gap:12px;border-left:4px solid transparent}
.ann-banner.info{background:#EEF4FF;border-left-color:#534AB7}
.ann-banner.warning{background:#FEFCE8;border-left-color:#CA8A04}
.ann-banner.success{background:#ECFDF5;border-left-color:#1D9E75}
.ann-icon{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.ann-banner.info .ann-icon{background:#EEEDFE}
.ann-banner.warning .ann-icon{background:#FEF9C3}
.ann-banner.success .ann-icon{background:#D1FAE5}
.ann-icon svg{width:13px;height:13px}
.ann-banner.info .ann-icon svg{color:#534AB7}
.ann-banner.warning .ann-icon svg{color:#CA8A04}
.ann-banner.success .ann-icon svg{color:#1D9E75}
.ann-title{font-size:13px;font-weight:700;color:#1a1a2e}
.ann-msg{font-size:12px;color:#4b5563;margin-top:2px;line-height:1.55}
.ann-meta{font-size:11px;color:#9ca3af;margin-top:4px}

.hero{background:#fff;border:1px solid #e8e8f0;border-radius:14px;overflow:hidden;display:flex}
.hero-bar{width:5px;background:#534AB7;flex-shrink:0}
.hero-inner{display:flex;align-items:center;gap:18px;padding:18px 22px;flex:1;flex-wrap:wrap}
.big-av{width:68px;height:68px;border-radius:50%;background:#EEEDFE;border:2.5px solid #AFA9EC;overflow:hidden;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:700;color:#534AB7}
.big-av img{width:100%;height:100%;object-fit:cover}
.hero-info{flex:1;min-width:160px}
.hero-name{font-size:19px;font-weight:700;color:#1a1a2e}
.hero-sub{font-size:12px;color:#6b7280;margin-top:2px}
.tags{display:flex;gap:5px;margin-top:8px;flex-wrap:wrap}
.tag{font-size:11px;font-weight:500;padding:3px 10px;border-radius:20px}
.tag-purple{background:#EEEDFE;color:#3C3489}
.tag-teal{background:#E1F5EE;color:#085041}
.tag-amber{background:#FAEEDA;color:#633806}
.tag-blue{background:#E6F1FB;color:#0C447C}
.hero-upload{display:flex;flex-direction:column;gap:6px;align-items:flex-end}
.btn-sm{padding:6px 14px;border-radius:7px;border:1px solid #e0e0f0;background:#f7f7ff;color:#6b7280;font-size:12px;cursor:pointer}
.btn-sm:hover{background:#EEEDFE;color:#534AB7;border-color:#AFA9EC}
.prog-bar{width:110px;height:4px;background:#e8e8f0;border-radius:4px;overflow:hidden}
.prog-fill{height:100%;background:#534AB7;border-radius:4px}

.stats-row{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px}
.sc{background:#fff;border:1px solid #e8e8f0;border-radius:12px;padding:14px 16px;position:relative;overflow:hidden}
.sc-top{height:3px;position:absolute;top:0;left:0;right:0}
.sc-icon{position:absolute;top:12px;right:12px;width:28px;height:28px;border-radius:8px;display:flex;align-items:center;justify-content:center}
.sc-label{font-size:11px;color:#6b7280;font-weight:600;margin-top:4px;text-transform:uppercase;letter-spacing:.04em}
.sc-value{font-size:24px;font-weight:700;color:#1a1a2e;margin-top:4px}
.sc-sub{font-size:11px;color:#9ca3af;margin-top:2px}

.section-card{background:#fff;border:1px solid #e8e8f0;border-radius:14px;overflow:hidden}
.section-head{padding:16px 22px;border-bottom:1px solid #e8e8f0;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:8px}
.section-title{font-size:14px;font-weight:700;color:#1a1a2e}
.section-sub{font-size:12px;color:#6b7280;margin-top:2px}
.section-body{padding:20px 22px}
.section-foot{padding:14px 22px;border-top:1px solid #e8e8f0;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:8px}
.hint{font-size:12px;color:#9ca3af}
.badge{font-size:11px;font-weight:500;padding:3px 10px;border-radius:20px;background:#EEEDFE;color:#3C3489}
.badge-green{background:#E1F5EE;color:#085041}
.badge-amber{background:#FAEEDA;color:#633806}

.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.form-grid.full{grid-template-columns:1fr}
.field{display:flex;flex-direction:column;gap:4px}
.field label{font-size:11px;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.04em}
.field input,.field select,.field textarea{padding:9px 12px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;color:#1a1a2e;background:#fafafa;outline:none;font-family:inherit;transition:border-color .12s,box-shadow .12s}
.field input:focus,.field select:focus,.field textarea:focus{border-color:#534AB7;background:#fff;box-shadow:0 0 0 3px #EEEDFE}

.btn-primary{padding:10px 24px;background:#534AB7;color:#fff;border:none;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;transition:background .15s}
.btn-primary:hover{background:#3C3489}
.btn-send{padding:9px 18px;background:#534AB7;color:#fff;border:none;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;flex-shrink:0}
.btn-send:hover{background:#3C3489}

.elective-card{border:1px solid #e8e8f0;border-radius:10px;padding:14px 16px;margin-bottom:10px;background:#fafafa;border-left:4px solid #534AB7}
.elective-card h3{font-size:14px;font-weight:700;color:#534AB7}
.elective-card p{font-size:12px;color:#6b7280;margin-top:3px}
.elective-card.green{border-left-color:#1D9E75}
.elective-card.green h3{color:#0F6E56}

.chat-window{max-height:320px;overflow-y:auto;margin-bottom:12px;display:flex;flex-direction:column;gap:8px;padding:4px 0}
.msg{display:flex}
.msg.student{justify-content:flex-end}
.msg.admin{justify-content:flex-start}
.bubble{max-width:70%;padding:9px 13px;border-radius:12px;font-size:13px;line-height:1.5}
.msg.student .bubble{background:#EEEDFE;color:#3C3489;border-bottom-right-radius:3px}
.msg.admin .bubble{background:#E1F5EE;color:#085041;border-bottom-left-radius:3px}
.bubble .sender{font-size:10px;font-weight:700;opacity:.7;margin-bottom:3px}
.satisfy-btns{display:flex;gap:6px;margin-top:7px}
.btn-sat{padding:4px 10px;border-radius:6px;border:none;font-size:12px;cursor:pointer;font-weight:600}
.btn-sat.yes{background:#1D9E75;color:#fff}
.btn-sat.no{background:#E24B4A;color:#fff}
.chat-input{display:flex;gap:8px}
.chat-input input{flex:1;padding:9px 14px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;outline:none;background:#fafafa}
.chat-input input:focus{border-color:#534AB7;box-shadow:0 0 0 3px #EEEDFE;background:#fff}

.charts-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.chart-box{background:#fafafa;border:1px solid #e8e8f0;border-radius:10px;padding:16px}
.chart-box.wide{grid-column:span 2}
.chart-box canvas{max-height:220px}

.section{display:none}
.section.active{display:block}

.interest-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin:8px 0 14px}
.interest-btn{padding:12px;border-radius:10px;border:1.5px solid #e0e0f0;background:#fafafa;text-align:center;cursor:pointer;font-size:13px;font-weight:600;color:#6b7280;transition:all .15s}
.interest-btn:hover,.interest-btn.selected{border-color:#534AB7;background:#EEEDFE;color:#534AB7}

.toast{position:fixed;bottom:28px;right:28px;padding:12px 20px;border-radius:10px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px;z-index:9999;opacity:0;transform:translateY(10px);transition:opacity .3s,transform .3s;pointer-events:none}
.toast.success{background:#1D9E75;color:#fff}
.toast.error{background:#E24B4A;color:#fff}
.toast.show{opacity:1;transform:translateY(0)}

/* Feedback styles */
.star-row{display:flex;gap:6px;margin-top:6px}
.star{font-size:32px;color:#e0e0f0;cursor:pointer;transition:color .1s,transform .1s;user-select:none;line-height:1}
.star:hover,.star.lit{color:#f59e0b}
.star:hover{transform:scale(1.12)}
.fb-card{border:1px solid #e8e8f0;border-radius:10px;padding:14px 16px;margin-bottom:10px;background:#fafafa;border-left:4px solid #534AB7}
.fb-card-head{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:6px;margin-bottom:6px}
.fb-card-name{font-size:13px;font-weight:700;color:#1a1a2e}
.fb-stars{color:#f59e0b;font-size:16px;letter-spacing:2px}
.fb-comment{font-size:12px;color:#6b7280;margin-top:4px;line-height:1.6}
.fb-date{font-size:11px;color:#c0c0d0;margin-top:5px}
.fb-empty{text-align:center;padding:36px 0}
.fb-empty-icon{width:52px;height:52px;background:#EEEDFE;border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 12px}
.fb-empty-icon svg{width:24px;height:24px}
.fb-empty-title{font-size:14px;font-weight:700;color:#1a1a2e;margin-bottom:5px}
.fb-empty-sub{font-size:12px;color:#9ca3af}
.past-label{font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;letter-spacing:.05em;margin-bottom:12px;padding-top:18px;border-top:1px solid #f0f0f8;margin-top:18px}

/* Notification section styles */
.notif-section-list{display:flex;flex-direction:column;gap:8px}
.notif-row{display:flex;align-items:flex-start;gap:12px;padding:13px 16px;border:1px solid #e8e8f0;border-radius:10px;background:#fafafa;transition:background .12s}
.notif-row.unread-row{background:#f5f3ff;border-color:#AFA9EC}
.notif-row-icon{width:34px;height:34px;border-radius:9px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.notif-row-icon svg{width:14px;height:14px}
.notif-row-text{flex:1}
.notif-row-msg{font-size:13px;color:#1a1a2e;line-height:1.5}
.notif-row-time{font-size:11px;color:#9ca3af;margin-top:3px}
.unread-pill{font-size:10px;font-weight:700;padding:2px 7px;border-radius:20px;background:#534AB7;color:#fff;flex-shrink:0;margin-top:3px}
</style>
</head>
<body>

<div class="toast <%= hasError ? "error" : "success" %>" id="toast">
    <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <circle cx="8" cy="8" r="6.5" stroke="white" stroke-width="1.5"/>
        <% if (hasError) { %>
        <path d="M5.5 5.5l5 5M10.5 5.5l-5 5" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
        <% } else { %>
        <path d="M5 8l2 2 4-4" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        <% } %>
    </svg>
    <%= hasError ? "Could not save. Please try again." : "Saved successfully!" %>
</div>

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
            Welcome, <%= name %>
        </div>

        <!-- NOTIFICATION BELL -->
        <div class="bell-wrap" id="bellWrap">
            <div class="bell-btn" id="bellBtn" onclick="toggleNotifDropdown()">
                <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4">
                    <path d="M8 2a4 4 0 0 1 4 4v2l1 2H3l1-2V6a4 4 0 0 1 4-4z"/>
                    <path d="M6.5 12a1.5 1.5 0 0 0 3 0" stroke-linecap="round"/>
                </svg>
            </div>
            <div class="notif-badge <%= unreadCount > 0 ? "show" : "" %>" id="notifBadge">
                <%= unreadCount > 9 ? "9+" : String.valueOf(unreadCount) %>
            </div>

            <!-- Dropdown -->
            <div class="notif-dropdown" id="notifDropdown">
                <div class="notif-drop-head">
                    <span class="notif-drop-title">Notifications</span>
                    <% if (unreadCount > 0) { %>
                    <button class="mark-all-btn" onclick="markAllRead()">Mark all as read</button>
                    <% } %>
                </div>
                <div class="notif-list">
                    <% if (notifList.isEmpty()) { %>
                    <div class="notif-empty">No notifications yet</div>
                    <% } else { for (Document nd : notifList) {
                           boolean isUnread = !Boolean.TRUE.equals(nd.getBoolean("read"));
                           String ntype = nd.getString("type") != null ? nd.getString("type") : "info";
                           String iconBg = "announcement".equals(ntype) ? "#FEF3C7" : "query".equals(ntype) ? "#E1F5EE" : "#EEEDFE";
                           String iconColor = "announcement".equals(ntype) ? "#B45309" : "query".equals(ntype) ? "#0F6E56" : "#534AB7";
                    %>
                    <div class="notif-item <%= isUnread ? "unread" : "" %>">
                        <div class="notif-icon" style="background:<%= iconBg %>">
                            <% if ("announcement".equals(ntype)) { %>
                            <svg viewBox="0 0 16 16" fill="none" stroke="<%= iconColor %>" stroke-width="1.4"><rect x="2" y="3" width="12" height="10" rx="1.5" fill="none"/><path d="M5 7h6M5 10h4" stroke-linecap="round"/></svg>
                            <% } else if ("query".equals(ntype)) { %>
                            <svg viewBox="0 0 16 16" fill="none" stroke="<%= iconColor %>" stroke-width="1.4"><path d="M3 3h10a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" fill="none"/></svg>
                            <% } else { %>
                            <svg viewBox="0 0 16 16" fill="none" stroke="<%= iconColor %>" stroke-width="1.4"><circle cx="8" cy="8" r="5.5"/><path d="M8 5v3l2 2" stroke-linecap="round"/></svg>
                            <% } %>
                        </div>
                        <div class="notif-text">
                            <div class="notif-msg"><%= nd.getString("message") %></div>
                            <div class="notif-time"><%= nd.getString("timestamp") != null ? nd.getString("timestamp").substring(0,24) : "" %></div>
                        </div>
                        <% if (isUnread) { %><div class="unread-dot"></div><% } %>
                    </div>
                    <% } } %>
                </div>
                <div class="notif-drop-foot">
                    <a onclick="showSection('notifications', document.getElementById('nav-notifications')); closeNotifDropdown()">
                        View all notifications
                    </a>
                </div>
            </div>
        </div>

        <a href="logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="layout">
    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-label">Main</div>
        <div class="nav-item" id="nav-academic" onclick="showSection('academic',this)">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="2" width="5" height="5" rx="1" fill="#534AB7"/><rect x="9" y="2" width="5" height="5" rx="1" fill="#534AB7" opacity=".4"/><rect x="2" y="9" width="5" height="5" rx="1" fill="#534AB7" opacity=".4"/><rect x="9" y="9" width="5" height="5" rx="1" fill="#534AB7" opacity=".4"/></svg>
            Academic
        </div>
        <div class="nav-item" id="nav-recommend" onclick="showSection('recommend',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="currentColor" stroke-width="1.2" fill="none" stroke-linejoin="round"/></svg>
            Recommend
        </div>
        <div class="nav-item" id="nav-analytics" onclick="showSection('analytics',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M2 12L5 8L8 10L11 5L14 7" stroke="currentColor" stroke-width="1.3" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Analytics
        </div>
        <div class="sidebar-label">Support</div>
        <div class="nav-item" id="nav-query" onclick="showSection('query',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M3 3h10a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" stroke="currentColor" stroke-width="1.2" fill="none"/></svg>
            Query
        </div>
        <div class="nav-item" id="nav-answers" onclick="showSection('answers',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M3 4h10M3 8h7M3 12h5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
            My Queries
        </div>
        <div class="nav-item" id="nav-electives" onclick="showSection('electives',this)">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="9" rx="1.5" stroke="currentColor" stroke-width="1.2" fill="none"/><path d="M5 4V3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1" stroke="currentColor" stroke-width="1.2"/></svg>
            Electives
        </div>
        <div class="nav-item" id="nav-selected" onclick="showSection('selected',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M2 5h12M2 8h8M2 11h5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><circle cx="13" cy="11" r="2.5" stroke="currentColor" stroke-width="1.2"/><path d="M12.3 11l.7.7 1.3-1.3" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"/></svg>
            My Electives
        </div>
        <div class="nav-item" id="nav-feedback" onclick="showSection('feedback',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="currentColor" stroke-width="1.2" fill="none" stroke-linejoin="round"/></svg>
            Feedback
        </div>
        <div class="sidebar-label">Updates</div>
        <div class="nav-item" id="nav-announcements" onclick="showSection('announcements',this)">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="3" width="12" height="10" rx="1.5" stroke="currentColor" stroke-width="1.2" fill="none"/><path d="M5 7h6M5 10h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
            Announcements
            <% if (!announcements.isEmpty()) { %>
            <span style="margin-left:auto;background:#534AB7;color:#fff;font-size:10px;font-weight:700;padding:1px 6px;border-radius:10px;"><%= announcements.size() %></span>
            <% } %>
        </div>
        <div class="nav-item" id="nav-notifications" onclick="showSection('notifications',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M8 2a4 4 0 0 1 4 4v2l1 2H3l1-2V6a4 4 0 0 1 4-4z" stroke="currentColor" stroke-width="1.2" fill="none"/><path d="M6.5 12a1.5 1.5 0 0 0 3 0" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
            Notifications
            <div class="nav-notif-dot <%= unreadCount > 0 ? "show" : "" %>" id="navDot"></div>
        </div>
        <div class="sidebar-label">Account</div>
        <div class="nav-item" onclick="openSwing()">
            <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5.5" r="2.5" stroke="currentColor" stroke-width="1.2"/><path d="M3 14c0-2.76 2.24-5 5-5s5 2.24 5 5" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
            Student Profile
        </div>
    </div>

    <div class="content">

        <!-- ANNOUNCEMENT BANNERS (always visible if any) -->
        <% if (!announcements.isEmpty()) { %>
        <div class="ann-feed">
            <% for (Document ann : announcements) {
                   String atype = ann.getString("type") != null ? ann.getString("type") : "info";
            %>
            <div class="ann-banner <%= atype %>">
                <div class="ann-icon">
                    <% if ("warning".equals(atype)) { %>
                    <svg viewBox="0 0 16 16" fill="none"><path d="M8 3L14 13H2L8 3z" stroke="currentColor" stroke-width="1.3" fill="none" stroke-linejoin="round"/><path d="M8 7v3M8 11.5v.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                    <% } else if ("success".equals(atype)) { %>
                    <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><path d="M5.5 8l2 2 3-3" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    <% } else { %>
                    <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="3" width="12" height="10" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7h6M5 10h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
                    <% } %>
                </div>
                <div>
                    <div class="ann-title"><%= ann.getString("title") %></div>
                    <div class="ann-msg"><%= ann.getString("message") %></div>
                    <div class="ann-meta">Posted by Admin &nbsp;·&nbsp; <%= ann.getString("timestamp") != null ? ann.getString("timestamp").substring(0,24) : "" %></div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>

        <!-- HERO -->
        <div class="hero">
            <div class="hero-bar"></div>
            <div class="hero-inner">
                <div class="big-av">
                    <% if (photo != null && !photo.isEmpty()) { %>
                        <img src="images/<%= photo %>" alt="Photo">
                    <% } else { %><%= initials %><% } %>
                </div>
                <div class="hero-info">
                    <div class="hero-name"><%= name %></div>
                    <div class="hero-sub">ID: <%= studentId %> &nbsp;·&nbsp; Computer Science Engineering</div>
                    <div class="tags">
                        <span class="tag tag-purple"><%= statBranch.isEmpty() ? "Branch" : statBranch %></span>
                        <span class="tag tag-teal">Semester <%= statSem.equals("—") ? "—" : statSem %></span>
                        <span class="tag tag-amber">CGPA <%= statCgpa %></span>
                        <span class="tag tag-blue"><%= statGoal.equals("—") ? "Goal" : statGoal %></span>
                    </div>
                </div>
                <div class="hero-upload">
                    <form action="uploadPhoto" method="post" enctype="multipart/form-data"
                          style="display:flex;flex-direction:column;align-items:flex-end;gap:6px;">
                        <input type="file" name="photo" accept="image/*" style="font-size:12px;color:#6b7280;max-width:170px;">
                        <button type="submit" class="btn-sm">Upload Photo</button>
                    </form>
                    <div style="font-size:11px;color:#9ca3af;">Profile complete</div>
                    <div class="prog-bar"><div class="prog-fill" style="width:75%"></div></div>
                </div>
            </div>
        </div>

        <!-- STAT CARDS -->
        <div class="stats-row">
            <div class="sc">
                <div class="sc-top" style="background:#534AB7"></div>
                <div class="sc-icon" style="background:#EEEDFE"><svg width="14" height="14" viewBox="0 0 16 16"><path d="M8 2L10 6h4l-3 3 1 4-4-2-4 2 1-4-3-3h4z" fill="#534AB7"/></svg></div>
                <div class="sc-label">CGPA</div>
                <div class="sc-value" id="statCgpa"><%= statCgpa %></div>
                <div class="sc-sub">out of 10.0</div>
            </div>
            <div class="sc">
                <div class="sc-top" style="background:#1D9E75"></div>
                <div class="sc-icon" style="background:#E1F5EE"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><path d="M2 12L5 8L8 10L12 5" stroke="#1D9E75" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg></div>
                <div class="sc-label">10th Score</div>
                <div class="sc-value" id="statTenth"><%= statTenth %></div>
                <div class="sc-sub">board exam</div>
            </div>
            <div class="sc">
                <div class="sc-top" style="background:#BA7517"></div>
                <div class="sc-icon" style="background:#FAEEDA"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="3" height="6" rx="1" fill="#BA7517" opacity=".5"/><rect x="7" y="4" width="3" height="9" rx="1" fill="#BA7517" opacity=".75"/><rect x="11" y="2" width="3" height="11" rx="1" fill="#BA7517"/></svg></div>
                <div class="sc-label">Coding Level</div>
                <div class="sc-value" id="statCoding" style="font-size:16px;margin-top:7px"><%= statCoding %></div>
                <div class="sc-sub">self-reported</div>
            </div>
            <div class="sc">
                <div class="sc-top" style="background:#185FA5"></div>
                <div class="sc-icon" style="background:#E6F1FB"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="5" stroke="#185FA5" stroke-width="1.5"/><path d="M8 5v3l2 2" stroke="#185FA5" stroke-width="1.5" stroke-linecap="round"/></svg></div>
                <div class="sc-label">Goal</div>
                <div class="sc-value" id="statGoal" style="font-size:16px;margin-top:7px"><%= statGoal %></div>
                <div class="sc-sub">career track</div>
            </div>
        </div>

        <div class="section-card">

            <!-- ACADEMIC -->
            <div id="academic" class="section">
                <div class="section-head"><div><div class="section-title">Academic Details</div><div class="section-sub">Keep your profile updated for better recommendations</div></div><span class="badge">Auto-saved on submit</span></div>
                <div class="section-body">
                    <form action="dashboard" method="post">
                        <div class="form-grid">
                            <div class="field"><label>Branch</label><input type="text" name="branch" value="<%= fBranch %>" placeholder="e.g. CSE"></div>
                            <div class="field"><label>Semester</label><input type="text" name="semester" value="<%= fSemester %>" placeholder="e.g. 5"></div>
                            <div class="field"><label>10th Percentage</label><input type="number" name="tenth" value="<%= fTenth %>" placeholder="e.g. 88"></div>
                            <div class="field"><label>12th Percentage</label><input type="number" name="twelfth" value="<%= fTwelfth %>" placeholder="e.g. 85"></div>
                            <div class="field"><label>CGPA</label><input type="number" step="0.01" name="cgpa" value="<%= fCgpa %>" placeholder="e.g. 8.2"></div>
                            <div class="field"><label>Coding Level</label><select name="codingLevel"><option value="Beginner" <%= "Beginner".equals(fCodingLevel) ? "selected" : "" %>>Beginner</option><option value="Intermediate" <%= "Intermediate".equals(fCodingLevel) ? "selected" : "" %>>Intermediate</option><option value="Advanced" <%= "Advanced".equals(fCodingLevel) ? "selected" : "" %>>Advanced</option></select></div>
                            <div class="field"><label>Goal</label><select name="goal"><option value="Placement" <%= "Placement".equals(fGoal) ? "selected" : "" %>>Placement</option><option value="Higher Studies" <%= "Higher Studies".equals(fGoal) ? "selected" : "" %>>Higher Studies</option><option value="Research" <%= "Research".equals(fGoal) ? "selected" : "" %>>Research</option><option value="Entrepreneurship" <%= "Entrepreneurship".equals(fGoal) ? "selected" : "" %>>Entrepreneurship</option></select></div>
                            <div class="field"><label>12th Stream</label><select name="stream"><option value="Science (PCM)" <%= "Science (PCM)".equals(fStream) ? "selected" : "" %>>Science (PCM)</option><option value="Science (PCB)" <%= "Science (PCB)".equals(fStream) ? "selected" : "" %>>Science (PCB)</option><option value="Commerce" <%= "Commerce".equals(fStream) ? "selected" : "" %>>Commerce</option><option value="Arts" <%= "Arts".equals(fStream) ? "selected" : "" %>>Arts</option></select></div>
                        </div>
                        <div class="section-foot" style="border-top:none;padding:16px 0 0;"><span class="hint"><% if(justSaved){%>Last saved: just now<%}else{%>Fill in your details and save<%}%></span><button type="submit" class="btn-primary">Save Changes</button></div>
                    </form>
                </div>
            </div>

            <!-- RECOMMEND -->
            <div id="recommend" class="section">
                <div class="section-head"><div><div class="section-title">Get Elective Recommendations</div><div class="section-sub">Choose your interest area and enter CGPA</div></div></div>
                <div class="section-body">
                    <form action="recommend" method="post">
                        <div class="field" style="margin-bottom:6px;"><label>Select Your Interest</label></div>
                        <div class="interest-grid">
                            <label class="interest-btn"><input type="radio" name="interest" value="AI" style="display:none"> AI / Machine Learning</label>
                            <label class="interest-btn"><input type="radio" name="interest" value="Web" style="display:none"> Web Development</label>
                            <label class="interest-btn"><input type="radio" name="interest" value="Cyber" style="display:none"> Cyber Security</label>
                            <label class="interest-btn"><input type="radio" name="interest" value="Data Science" style="display:none"> Data Science</label>
                        </div>
                        <div class="form-grid">
                            <div class="field"><label>Current CGPA</label><input type="number" step="0.01" name="cgpa" value="<%= fCgpa %>" placeholder="e.g. 8.2"></div>
                            <div class="field" style="justify-content:flex-end;padding-top:20px;"><button type="submit" class="btn-primary">Get Top Electives</button></div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ANALYTICS -->
            <div id="analytics" class="section">
                <div class="section-head"><div><div class="section-title">Analytics Dashboard</div><div class="section-sub">Your academic performance overview</div></div><span class="badge badge-green">Live Data</span></div>
                <div class="section-body">
                    <div class="charts-grid">
                        <div class="chart-box"><canvas id="barChart"></canvas></div>
                        <div class="chart-box"><canvas id="pieChart"></canvas></div>
                        <div class="chart-box wide"><canvas id="lineChart"></canvas></div>
                    </div>
                </div>
            </div>

            <!-- QUERY -->
            <div id="query" class="section">
                <div class="section-head"><div><div class="section-title">Ask a Query</div><div class="section-sub">Send a message to admin — we'll reply shortly</div></div></div>
                <div class="section-body">
                    <form action="query" method="post" class="form-grid full">
                        <div class="field"><label>Your Question</label><textarea name="query" rows="4" placeholder="Type your question here..."></textarea></div>
                        <div style="display:flex;justify-content:flex-end;"><button type="submit" class="btn-primary">Send Query</button></div>
                    </form>
                </div>
            </div>

            <!-- MY QUERIES -->
            <div id="answers" class="section">
                <div class="section-head"><div><div class="section-title">My Queries</div><div class="section-sub">Chat thread with admin</div></div></div>
                <div class="section-body">
                <%
                try {
                    com.mongodb.client.MongoClient mclient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
                    com.mongodb.client.MongoCollection<Document> mcol = mclient.getDatabase("electiveDB").getCollection("queries");
                    Document q = mcol.find(eq("studentId", studentId)).first();
                    if (q != null) {
                        List<Document> messages = (List<Document>) q.get("messages");
                %>
                    <div class="chat-window" id="chatWindow">
                    <% if (messages != null) { for (Document m : messages) { String sender = m.getString("sender"); String text = m.getString("text"); boolean isStu = "student".equals(sender); %>
                        <div class="msg <%= isStu ? "student" : "admin" %>">
                            <div class="bubble"><div class="sender"><%= sender %></div><%= text %>
                                <% if ("admin".equals(sender)) { %><form action="satisfy" method="post" class="satisfy-btns"><button name="status" value="satisfied" class="btn-sat yes">Satisfied</button><button name="status" value="not_satisfied" class="btn-sat no">Not satisfied</button></form><% } %>
                            </div>
                        </div>
                    <% } } %>
                    </div>
                    <form action="query" method="post" class="chat-input"><input type="text" name="query" placeholder="Type your message..."><button type="submit" class="btn-send">Send</button></form>
                <% } else { %>
                    <p style="color:#9ca3af;font-size:13px;margin-bottom:14px;">No queries yet. Start the conversation below.</p>
                    <form action="query" method="post" class="chat-input"><input type="text" name="query" placeholder="Ask something..."><button type="submit" class="btn-send">Send</button></form>
                <% } mclient.close(); } catch (Exception ex) { out.println("<p style='color:#E24B4A;font-size:13px;'>Error loading queries.</p>"); } %>
                </div>
            </div>

            <!-- ELECTIVES -->
            <div id="electives" class="section">
                <div class="section-head"><div><div class="section-title">Available Electives</div><div class="section-sub">Browse all electives offered this semester</div></div></div>
                <div class="section-body">
                <%
                try {
                    com.mongodb.client.MongoClient eclient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
                    com.mongodb.client.MongoCollection<Document> ecol = eclient.getDatabase("electiveDB").getCollection("electives");
                    List<Document> elist = ecol.find().into(new ArrayList<>());
                    if (elist.isEmpty()) { %><p style="color:#9ca3af;font-size:13px;">No electives found.</p>
                    <% } else { for (Document e : elist) { %>
                    <div class="elective-card"><h3><%= e.getString("name") %></h3><p><strong>Domain:</strong> <%= e.getString("domain") %> &nbsp;·&nbsp; <strong>Difficulty:</strong> <%= e.getString("difficulty") %></p><p style="margin-top:5px;"><%= e.getString("description") %></p></div>
                    <% } } eclient.close();
                } catch (Exception ex) { out.println("<p style='color:#E24B4A;font-size:13px;'>Error loading electives.</p>"); } %>
                </div>
            </div>

            <!-- SELECTED ELECTIVES -->
            <div id="selected" class="section">
                <div class="section-head"><div><div class="section-title">My Selected Electives</div><div class="section-sub">Electives you have enrolled in</div></div></div>
                <div class="section-body">
                <%
                try {
                    com.mongodb.client.MongoClient sclient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
                    com.mongodb.client.MongoCollection<Document> scol = sclient.getDatabase("electiveDB").getCollection("selected_electives");
                    List<Document> slist = scol.find(new Document("studentId", studentId)).into(new ArrayList<>());
                    if (slist.isEmpty()) { %><p style="color:#9ca3af;font-size:13px;">No electives selected yet.</p>
                    <% } else { for (Document e : slist) { %>
                    <div class="elective-card green"><h3><%= e.getString("name") %></h3><p><%= e.getString("domain") %></p></div>
                    <% } } sclient.close();
                } catch (Exception ex) { out.println("<p style='color:#E24B4A;font-size:13px;'>Error loading selected electives.</p>"); } %>
                </div>
            </div>

            <!-- FEEDBACK -->
            <div id="feedback" class="section">
                <div class="section-head"><div><div class="section-title">Rate Your Electives</div><div class="section-sub">Share your experience — your feedback helps others choose better</div></div><span class="badge badge-amber">Visible to Admin</span></div>
                <div class="section-body">
                <%
                List<String> enrolledNames = new ArrayList<>();
                try {
                    com.mongodb.client.MongoClient fbSelClient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
                    com.mongodb.client.MongoCollection<Document> fbSelCol = fbSelClient.getDatabase("electiveDB").getCollection("selected_electives");
                    List<Document> fbSelList = fbSelCol.find(new Document("studentId", studentId)).into(new ArrayList<>());
                    for (Document fe : fbSelList) { String eName = fe.getString("name"); if (eName != null) enrolledNames.add(eName); }
                    fbSelClient.close();
                } catch (Exception ex) { }
                %>
                <% if (enrolledNames.isEmpty()) { %>
                    <div class="fb-empty"><div class="fb-empty-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="#534AB7" stroke-width="1.2" fill="none" stroke-linejoin="round"/></svg></div><div class="fb-empty-title">No electives enrolled yet</div><div class="fb-empty-sub">Enroll in an elective first, then come back to review.</div></div>
                <% } else { %>
                    <form action="feedback" method="post" id="feedbackForm">
                        <div class="field" style="margin-bottom:16px"><label>Select Elective</label><select name="electiveName" id="electiveSelect" required style="padding:9px 12px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;background:#fafafa;outline:none;font-family:inherit"><option value="">— Choose an elective —</option><% for (String en : enrolledNames) { %><option value="<%= en %>"><%= en %></option><% } %></select></div>
                        <div class="field" style="margin-bottom:16px"><label>Your Rating</label><div class="star-row" id="starRow"><span class="star" data-val="1">★</span><span class="star" data-val="2">★</span><span class="star" data-val="3">★</span><span class="star" data-val="4">★</span><span class="star" data-val="5">★</span></div><input type="hidden" name="rating" id="ratingInput" value=""><div style="font-size:11px;color:#9ca3af;margin-top:4px" id="ratingHint">Click a star to rate</div></div>
                        <div class="field" style="margin-bottom:18px"><label>Your Review</label><textarea name="comment" rows="3" style="padding:9px 12px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;background:#fafafa;outline:none;font-family:inherit;resize:vertical" placeholder="What did you like? What could be improved?"></textarea></div>
                        <div style="display:flex;justify-content:flex-end"><button type="submit" class="btn-primary" onclick="return validateFeedback()">Submit Feedback</button></div>
                    </form>
                    <%
                    try {
                        com.mongodb.client.MongoClient pfClient = com.mongodb.client.MongoClients.create("mongodb://localhost:27017");
                        com.mongodb.client.MongoCollection<Document> pfCol = pfClient.getDatabase("electiveDB").getCollection("feedback");
                        List<Document> myFbs = pfCol.find(new Document("studentId", studentId)).into(new ArrayList<>());
                        if (!myFbs.isEmpty()) {
                    %><div class="past-label">Your Previous Reviews</div>
                    <% for (Document fb : myFbs) { int stars = fb.getInteger("rating", 0); %>
                    <div class="fb-card"><div class="fb-card-head"><span class="fb-card-name"><%= fb.getString("electiveName") %></span><span class="fb-stars"><% for(int s=1;s<=5;s++){%><%= s<=stars?"★":"☆" %><% } %></span></div><% String cmt=fb.getString("comment"); if(cmt!=null&&!cmt.isEmpty()){%><div class="fb-comment"><%= cmt %></div><%}%><div class="fb-date"><%= fb.getString("timestamp") %></div></div>
                    <% } } pfClient.close(); } catch (Exception ex) { } %>
                <% } %>
                </div>
            </div>

            <!-- ═══ ANNOUNCEMENTS SECTION ═══ -->
            <div id="announcements" class="section">
                <div class="section-head">
                    <div>
                        <div class="section-title">Announcements</div>
                        <div class="section-sub">Important notices from admin</div>
                    </div>
                    <span class="badge badge-green"><%= announcements.size() %> Active</span>
                </div>
                <div class="section-body">
                <% if (announcements.isEmpty()) { %>
                    <div style="text-align:center;padding:36px 0">
                        <div style="width:52px;height:52px;background:#EEEDFE;border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 12px"><svg width="24" height="24" viewBox="0 0 16 16" fill="none"><rect x="2" y="3" width="12" height="10" rx="1.5" stroke="#534AB7" stroke-width="1.3" fill="none"/><path d="M5 7h6M5 10h4" stroke="#534AB7" stroke-width="1.2" stroke-linecap="round"/></svg></div>
                        <div style="font-size:14px;font-weight:700;color:#1a1a2e;margin-bottom:5px">No announcements yet</div>
                        <div style="font-size:12px;color:#9ca3af">Admin hasn't posted anything yet. Check back later.</div>
                    </div>
                <% } else { for (Document ann : announcements) { String atype = ann.getString("type") != null ? ann.getString("type") : "info"; %>
                    <div class="ann-banner <%= atype %>" style="margin-bottom:10px">
                        <div class="ann-icon">
                            <% if ("warning".equals(atype)) { %><svg viewBox="0 0 16 16" fill="none"><path d="M8 3L14 13H2L8 3z" stroke="currentColor" stroke-width="1.3" fill="none" stroke-linejoin="round"/><path d="M8 7v3M8 11.5v.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                            <% } else if ("success".equals(atype)) { %><svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><path d="M5.5 8l2 2 3-3" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
                            <% } else { %><svg viewBox="0 0 16 16" fill="none"><rect x="2" y="3" width="12" height="10" rx="1.5" stroke="currentColor" stroke-width="1.3" fill="none"/><path d="M5 7h6M5 10h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg><% } %>
                        </div>
                        <div>
                            <div class="ann-title"><%= ann.getString("title") %></div>
                            <div class="ann-msg"><%= ann.getString("message") %></div>
                            <div class="ann-meta">Posted by <%= ann.getString("postedBy") %> &nbsp;·&nbsp; <%= ann.getString("timestamp") != null ? ann.getString("timestamp").substring(0,24) : "" %></div>
                        </div>
                    </div>
                <% } } %>
                </div>
            </div>

            <!-- ═══ NOTIFICATIONS SECTION ═══ -->
            <div id="notifications" class="section">
                <div class="section-head">
                    <div>
                        <div class="section-title">All Notifications</div>
                        <div class="section-sub">Your activity feed — query replies, announcements, enrollments</div>
                    </div>
                    <% if (unreadCount > 0) { %>
                    <button class="btn-primary" style="padding:7px 16px;font-size:12px" onclick="markAllRead()">
                        Mark all read (<%= unreadCount %>)
                    </button>
                    <% } else { %>
                    <span class="badge badge-green">All caught up</span>
                    <% } %>
                </div>
                <div class="section-body">
                <% if (notifList.isEmpty()) { %>
                    <div style="text-align:center;padding:36px 0">
                        <div style="width:52px;height:52px;background:#EEEDFE;border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 12px"><svg width="24" height="24" viewBox="0 0 16 16" fill="none"><path d="M8 2a4 4 0 0 1 4 4v2l1 2H3l1-2V6a4 4 0 0 1 4-4z" stroke="#534AB7" stroke-width="1.3" fill="none"/><path d="M6.5 12a1.5 1.5 0 0 0 3 0" stroke="#534AB7" stroke-width="1.3"/></svg></div>
                        <div style="font-size:14px;font-weight:700;color:#1a1a2e;margin-bottom:5px">No notifications yet</div>
                        <div style="font-size:12px;color:#9ca3af">You'll see query replies and announcements here.</div>
                    </div>
                <% } else { %>
                    <div class="notif-section-list">
                    <% for (Document nd : notifList) {
                           boolean isUnread = !Boolean.TRUE.equals(nd.getBoolean("read"));
                           String ntype = nd.getString("type") != null ? nd.getString("type") : "info";
                           String iconBg = "announcement".equals(ntype) ? "#FEF3C7" : "query".equals(ntype) ? "#E1F5EE" : "#EEEDFE";
                           String iconColor = "announcement".equals(ntype) ? "#B45309" : "query".equals(ntype) ? "#0F6E56" : "#534AB7";
                    %>
                    <div class="notif-row <%= isUnread ? "unread-row" : "" %>">
                        <div class="notif-row-icon" style="background:<%= iconBg %>">
                            <% if ("announcement".equals(ntype)) { %><svg viewBox="0 0 16 16" fill="none" stroke="<%= iconColor %>" stroke-width="1.4"><rect x="2" y="3" width="12" height="10" rx="1.5" fill="none"/><path d="M5 7h6M5 10h4" stroke-linecap="round"/></svg>
                            <% } else if ("query".equals(ntype)) { %><svg viewBox="0 0 16 16" fill="none" stroke="<%= iconColor %>" stroke-width="1.4"><path d="M3 3h10a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" fill="none"/></svg>
                            <% } else { %><svg viewBox="0 0 16 16" fill="none" stroke="<%= iconColor %>" stroke-width="1.4"><circle cx="8" cy="8" r="5.5"/><path d="M8 5v3l2 2" stroke-linecap="round"/></svg><% } %>
                        </div>
                        <div class="notif-row-text">
                            <div class="notif-row-msg"><%= nd.getString("message") %></div>
                            <div class="notif-row-time"><%= nd.getString("timestamp") != null ? nd.getString("timestamp").substring(0,24) : "" %></div>
                        </div>
                        <% if (isUnread) { %><span class="unread-pill">New</span><% } %>
                    </div>
                    <% } %>
                    </div>
                <% } %>
                </div>
            </div>

        </div><!-- end section-card -->
    </div><!-- end content -->
</div><!-- end layout -->

<script>
let chartsLoaded = false;

function showSection(id, el) {
    document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    if (el) el.classList.add('active');
    if (id === 'analytics' && !chartsLoaded) { loadCharts(); chartsLoaded = true; }
    if (id === 'answers') { const cw = document.getElementById('chatWindow'); if (cw) setTimeout(() => cw.scrollTop = cw.scrollHeight, 50); }
    closeNotifDropdown();
}

/* Auto-open correct section */
(function () {
    const sec = '<%= openSec %>';
    const navEl = document.getElementById('nav-' + sec);
    if (document.getElementById(sec)) showSection(sec, navEl);
    else showSection('academic', document.getElementById('nav-academic'));
})();

/* Toast */
(function () {
    const show = <%= justSaved || hasError %>;
    if (!show) return;
    const t = document.getElementById('toast');
    if (!t) return;
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 3500);
    history.replaceState(null, '', window.location.pathname);
})();

/* ── NOTIFICATION DROPDOWN ── */
function toggleNotifDropdown() {
    document.getElementById('notifDropdown').classList.toggle('open');
}
function closeNotifDropdown() {
    document.getElementById('notifDropdown').classList.remove('open');
}
document.addEventListener('click', function(e) {
    const wrap = document.getElementById('bellWrap');
    if (wrap && !wrap.contains(e.target)) closeNotifDropdown();
});

/* ── MARK ALL READ ── */
function markAllRead() {
    fetch('notification?action=markRead', { method: 'POST' })
        .then(() => {
            document.querySelectorAll('.unread-dot,.unread-pill').forEach(el => el.remove());
            document.querySelectorAll('.notif-item.unread,.notif-row.unread-row').forEach(el => {
                el.classList.remove('unread','unread-row');
            });
            const badge = document.getElementById('notifBadge');
            if (badge) { badge.classList.remove('show'); badge.textContent = '0'; }
            const navDot = document.getElementById('navDot');
            if (navDot) navDot.classList.remove('show');
            const markBtn = document.querySelector('.mark-all-btn');
            if (markBtn) markBtn.remove();
        });
}

/* ── STAR RATING ── */
(function () {
    const stars = document.querySelectorAll('.star');
    const input = document.getElementById('ratingInput');
    const hint  = document.getElementById('ratingHint');
    if (!stars.length) return;
    const labels = ['','Poor','Fair','Good','Very Good','Excellent!'];
    stars.forEach(s => {
        s.addEventListener('click', function () {
            const val = +this.dataset.val;
            input.value = val;
            stars.forEach(st => st.classList.toggle('lit', +st.dataset.val <= val));
            hint.textContent = labels[val] + ' (' + val + '/5)';
            hint.style.color = val >= 4 ? '#1D9E75' : val >= 3 ? '#BA7517' : '#ef4444';
        });
        s.addEventListener('mouseenter', function () {
            const val = +this.dataset.val;
            stars.forEach(st => st.style.color = +st.dataset.val <= val ? '#f59e0b' : '');
        });
        s.addEventListener('mouseleave', () => stars.forEach(st => st.style.color = ''));
    });
})();

function validateFeedback() {
    if (!document.getElementById('electiveSelect').value) { alert('Please select an elective.'); return false; }
    if (!document.getElementById('ratingInput').value)   { alert('Please click a star to rate.'); return false; }
    return true;
}

function loadCharts() {
    const cgpaRaw  = parseFloat(document.getElementById('statCgpa').innerText)  || 8.2;
    const tenthRaw = parseFloat(document.getElementById('statTenth').innerText) || 88;
    new Chart(document.getElementById('barChart'), { type:'bar', data:{ labels:['10th %','12th %','CGPA×10'], datasets:[{ label:'Score', data:[tenthRaw, Math.max(tenthRaw-3,0), Math.round(cgpaRaw*10)], backgroundColor:['#534AB7','#7F77DD','#AFA9EC'], borderRadius:6, borderSkipped:false }] }, options:{ responsive:true, plugins:{ legend:{display:false}, title:{display:true,text:'Academic Scores',font:{size:13,weight:'600'}} }, scales:{ y:{beginAtZero:true,max:100,grid:{color:'#f0f0f8'}}, x:{grid:{display:false}} } } });
    new Chart(document.getElementById('pieChart'), { type:'doughnut', data:{ labels:['AI','Web','Cyber','Data Science'], datasets:[{ data:[30,25,20,25], backgroundColor:['#534AB7','#1D9E75','#BA7517','#185FA5'], borderWidth:2, borderColor:'#fff' }] }, options:{ responsive:true, plugins:{ legend:{position:'bottom',labels:{boxWidth:12,font:{size:12}}}, title:{display:true,text:'Interest Distribution',font:{size:13,weight:'600'}} } } });
    new Chart(document.getElementById('lineChart'), { type:'line', data:{ labels:['Sem 1','Sem 2','Sem 3','Sem 4','Sem 5'], datasets:[{ label:'CGPA Trend', data:[7.5,7.8,8.0,8.1,cgpaRaw], borderColor:'#534AB7', backgroundColor:'#EEEDFE', fill:true, tension:0.4, pointBackgroundColor:'#534AB7', pointRadius:5 }] }, options:{ responsive:true, plugins:{ legend:{display:false}, title:{display:true,text:'CGPA Trend Over Semesters',font:{size:13,weight:'600'}} }, scales:{ y:{min:6,max:10,grid:{color:'#f0f0f8'}}, x:{grid:{display:false}} } } });
}

document.querySelectorAll('.interest-btn').forEach(btn => {
    btn.addEventListener('click', function () {
        document.querySelectorAll('.interest-btn').forEach(b => b.classList.remove('selected'));
        this.classList.add('selected');
    });
});

function openSwing() { window.location.href = "openSwing"; }
</script>
</body>
</html>
