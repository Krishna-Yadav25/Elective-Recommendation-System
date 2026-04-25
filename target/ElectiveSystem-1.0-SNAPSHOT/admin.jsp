<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, org.bson.Document" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("index.jsp"); return; }
    String adminName = (String) session.getAttribute("name");
    String initials = adminName != null && adminName.length() >= 2
        ? adminName.substring(0,2).toUpperCase()
        : (adminName != null ? adminName.substring(0,1).toUpperCase() : "AD");
    boolean justSaved = "true".equals(request.getParameter("saved"));
    boolean hasError  = "true".equals(request.getParameter("error"));
    String  openSec   = request.getParameter("section") != null ? request.getParameter("section") : "add";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Panel — Elective Recommendation System</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f0f2ff;color:#1a1a2e;min-height:100vh}
.topbar{background:#fff;border-bottom:1px solid #e8e8f0;padding:0 28px;height:58px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100}
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
.layout{display:flex;min-height:calc(100vh - 58px)}
.sidebar{width:215px;flex-shrink:0;background:#fff;border-right:1px solid #e8e8f0;padding:16px 0;display:flex;flex-direction:column;position:sticky;top:58px;height:calc(100vh - 58px);overflow-y:auto}
.sidebar-label{padding:10px 16px 4px;font-size:10px;font-weight:700;color:#9ca3af;letter-spacing:.06em;text-transform:uppercase}
.nav-item{display:flex;align-items:center;gap:9px;padding:9px 16px;font-size:13px;color:#6b7280;cursor:pointer;border-left:2.5px solid transparent;transition:all .12s;user-select:none}
.nav-item:hover{background:#f5f3ff;color:#534AB7}
.nav-item.active{color:#534AB7;background:#EEEDFE;border-left-color:#534AB7;font-weight:600}
.nav-item svg{width:15px;height:15px;flex-shrink:0}
.content{flex:1;padding:22px;display:flex;flex-direction:column;gap:18px}
.hero{background:#fff;border:1px solid #e8e8f0;border-radius:14px;overflow:hidden;display:flex}
.hero-bar{width:5px;background:#534AB7;flex-shrink:0}
.hero-inner{display:flex;align-items:center;gap:18px;padding:18px 22px;flex:1;flex-wrap:wrap}
.big-av{width:68px;height:68px;border-radius:50%;background:#EEEDFE;border:2.5px solid #AFA9EC;display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:700;color:#534AB7;flex-shrink:0}
.hero-info{flex:1;min-width:160px}
.hero-name{font-size:19px;font-weight:700;color:#1a1a2e}
.hero-sub{font-size:12px;color:#6b7280;margin-top:2px}
.tags{display:flex;gap:5px;margin-top:8px;flex-wrap:wrap}
.tag{font-size:11px;font-weight:500;padding:3px 10px;border-radius:20px}
.tag-purple{background:#EEEDFE;color:#3C3489}
.tag-red{background:#FEE2E2;color:#991B1B}
.tag-teal{background:#E1F5EE;color:#085041}
.stats-row{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:12px}
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
.badge{font-size:11px;font-weight:500;padding:3px 10px;border-radius:20px;background:#EEEDFE;color:#3C3489}
.badge-red{background:#FEE2E2;color:#991B1B}
.badge-green{background:#E1F5EE;color:#085041}
.badge-amber{background:#FAEEDA;color:#633806}
.section{display:none}
.section.active{display:block}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.field{display:flex;flex-direction:column;gap:4px}
.field label{font-size:11px;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.04em}
.field input,.field select,.field textarea{padding:9px 12px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;color:#1a1a2e;background:#fafafa;outline:none;font-family:inherit;transition:border-color .12s,box-shadow .12s}
.field input:focus,.field select:focus,.field textarea:focus{border-color:#534AB7;background:#fff;box-shadow:0 0 0 3px #EEEDFE}
.btn-primary{padding:10px 24px;background:#534AB7;color:#fff;border:none;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;transition:background .15s}
.btn-primary:hover{background:#3C3489}
.btn-danger{padding:10px 24px;background:#ef4444;color:#fff;border:none;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer}
.btn-danger:hover{background:#dc2626}
.btn-success{padding:9px 18px;background:#1D9E75;color:#fff;border:none;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer}
.btn-success:hover{background:#0F6E56}
.btn-secondary{padding:9px 18px;background:#f0f2ff;color:#534AB7;border:1px solid #AFA9EC;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer}
.btn-sm-red{padding:5px 12px;background:#FEE2E2;color:#991B1B;border:none;border-radius:7px;font-size:11px;font-weight:600;cursor:pointer}
.btn-sm-red:hover{background:#ef4444;color:#fff}
.data-table{width:100%;border-collapse:collapse;font-size:13px}
.data-table th{padding:10px 14px;background:#f5f3ff;color:#534AB7;font-weight:700;font-size:11px;text-transform:uppercase;letter-spacing:.04em;text-align:left;border-bottom:2px solid #e8e8f0}
.data-table td{padding:10px 14px;border-bottom:1px solid #f0f0f8;color:#1a1a2e}
.data-table tr:last-child td{border-bottom:none}
.data-table tr:hover td{background:#faf9ff}
.elective-card{border:1px solid #e8e8f0;border-radius:10px;padding:14px 16px;margin-bottom:10px;background:#fafafa;border-left:4px solid #534AB7;display:flex;align-items:center;justify-content:space-between;gap:12px}
.elective-card h3{font-size:14px;font-weight:700;color:#534AB7}
.elective-card p{font-size:12px;color:#6b7280;margin-top:2px}
.query-block{border:1px solid #e8e8f0;border-radius:12px;margin-bottom:14px;overflow:hidden}
.query-block-head{padding:10px 16px;background:#f5f3ff;border-bottom:1px solid #e8e8f0;display:flex;align-items:center;gap:8px}
.query-sid{font-size:12px;font-weight:700;color:#534AB7}
.chat-window{max-height:220px;overflow-y:auto;padding:12px 16px;display:flex;flex-direction:column;gap:7px}
.msg{display:flex}
.msg.student{justify-content:flex-start}
.msg.admin-msg{justify-content:flex-end}
.bubble{max-width:72%;padding:8px 12px;border-radius:10px;font-size:13px;line-height:1.5}
.msg.student .bubble{background:#e5e7eb;color:#1a1a2e;border-bottom-left-radius:3px}
.msg.admin-msg .bubble{background:#E1F5EE;color:#085041;border-bottom-right-radius:3px}
.bubble .sender{font-size:10px;font-weight:700;opacity:.6;margin-bottom:2px}
.reply-form{padding:10px 16px;border-top:1px solid #e8e8f0;display:flex;gap:8px;background:#fafafa}
.reply-form input{flex:1;padding:8px 12px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;outline:none;background:#fff}
.reply-form input:focus{border-color:#534AB7;box-shadow:0 0 0 3px #EEEDFE}
.charts-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px}
.chart-box{background:#fafafa;border:1px solid #e8e8f0;border-radius:10px;padding:16px}
.chart-box canvas{max-height:200px}
.toast{position:fixed;bottom:28px;right:28px;padding:12px 20px;border-radius:10px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px;z-index:9999;opacity:0;transform:translateY(10px);transition:opacity .3s,transform .3s;pointer-events:none}
.toast.success{background:#1D9E75;color:#fff}
.toast.error{background:#E24B4A;color:#fff}
.toast.show{opacity:1;transform:translateY(0)}
.pill{display:inline-block;font-size:11px;font-weight:600;padding:2px 9px;border-radius:20px}
.pill-easy{background:#E1F5EE;color:#085041}
.pill-medium{background:#FAEEDA;color:#633806}
.pill-hard{background:#FEE2E2;color:#991B1B}
.ann-card{border:1px solid #e8e8f0;border-radius:11px;padding:16px 18px;margin-bottom:10px;display:flex;align-items:flex-start;gap:14px;background:#fafafa}
.ann-card.info{border-left:4px solid #534AB7}
.ann-card.warning{border-left:4px solid #CA8A04}
.ann-card.success{border-left:4px solid #1D9E75}
.ann-card-icon{width:32px;height:32px;border-radius:9px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.ann-card.info .ann-card-icon{background:#EEEDFE}
.ann-card.warning .ann-card-icon{background:#FEF9C3}
.ann-card.success .ann-card-icon{background:#D1FAE5}
.ann-card-icon svg{width:14px;height:14px}
.ann-card-body{flex:1}
.ann-card-title{font-size:13px;font-weight:700;color:#1a1a2e}
.ann-card-msg{font-size:12px;color:#6b7280;margin-top:3px;line-height:1.55}
.ann-card-meta{font-size:11px;color:#9ca3af;margin-top:5px}
.type-grid{display:flex;gap:8px;margin-top:4px}
.type-btn{flex:1;padding:10px 8px;border:1.5px solid #e0e0f0;border-radius:9px;background:#fafafa;cursor:pointer;text-align:center;font-size:12px;font-weight:600;color:#6b7280;transition:all .12s}
.type-btn:hover{border-color:#AFA9EC;background:#EEEDFE;color:#534AB7}
.type-btn.sel-info{border-color:#534AB7;background:#EEEDFE;color:#3C3489}
.type-btn.sel-warning{border-color:#CA8A04;background:#FEF9C3;color:#713F12}
.type-btn.sel-success{border-color:#1D9E75;background:#D1FAE5;color:#065F46}
.fb-summary-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(165px,1fr));gap:10px;margin-bottom:22px}
.fb-summary-card{background:#fafafa;border:1px solid #e8e8f0;border-radius:10px;padding:12px 14px}
.fb-summary-name{font-size:12px;font-weight:700;color:#1a1a2e;margin-bottom:5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fb-stars-disp{color:#f59e0b;font-size:15px;letter-spacing:1px}
.fb-meta{font-size:11px;color:#6b7280;margin-top:3px}
.section-divider{font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;letter-spacing:.05em;margin-bottom:12px;padding-top:14px;border-top:1px solid #f0f0f8}
/* Syllabus upload */
.file-drop-zone{border:2px dashed #AFA9EC;border-radius:10px;padding:28px;text-align:center;cursor:pointer;background:#fafafa;transition:background .15s,border-color .15s}
.file-drop-zone:hover,.file-drop-zone.dragover{background:#EEEDFE;border-color:#534AB7}
.file-drop-icon{width:48px;height:48px;background:#EEEDFE;border-radius:12px;display:flex;align-items:center;justify-content:center;margin:0 auto 10px}
.file-drop-icon svg{width:22px;height:22px}
</style>
</head>
<body>

<div class="toast <%= hasError ? "error" : "success" %>" id="toast">
    <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <circle cx="8" cy="8" r="6.5" stroke="white" stroke-width="1.5"/>
        <% if (hasError) { %><path d="M5.5 5.5l5 5M10.5 5.5l-5 5" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
        <% } else { %><path d="M5 8l2 2 4-4" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/><% } %>
    </svg>
    <%= hasError ? "Something went wrong." : "Action completed successfully!" %>
</div>

<div class="topbar">
    <div class="logo">
        <div class="logo-mark"><svg viewBox="0 0 16 16" fill="none"><rect x="2" y="2" width="5" height="5" rx="1.5" fill="white"/><rect x="9" y="2" width="5" height="5" rx="1.5" fill="white" opacity=".5"/><rect x="2" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".5"/><rect x="9" y="9" width="5" height="5" rx="1.5" fill="white" opacity=".75"/></svg></div>
        <span class="logo-text">Elective <span>Recommendation</span> System</span>
    </div>
    <div class="topbar-right">
        <div class="user-chip"><div class="av"><%= initials %></div>Welcome, <%= adminName %></div>
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="layout">
    <div class="sidebar">
        <div class="sidebar-label">Manage</div>
        <div class="nav-item" id="nav-add" onclick="showSection('add',this)">
            <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><path d="M8 5.5v5M5.5 8h5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>Add Elective
        </div>
        <div class="nav-item" id="nav-delete" onclick="showSection('delete',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M3 4h10M6 4V3h4v1M5 4v8a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1V4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>Delete Elective
        </div>
        <div class="nav-item" id="nav-list" onclick="showSection('list',this)">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="9" rx="1.5" stroke="currentColor" stroke-width="1.2" fill="none"/><path d="M5 4V3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1" stroke="currentColor" stroke-width="1.2"/></svg>All Electives
        </div>
        <!-- ★ NEW: Syllabus Upload -->
        <div class="nav-item" id="nav-syllabus" onclick="showSection('syllabus',this)">
            <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="2" width="10" height="12" rx="1.5" stroke="currentColor" stroke-width="1.2"/><path d="M5 6h6M5 9h6M5 12h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/><path d="M10 2v3h3" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/></svg>Upload Syllabus
        </div>
        <div class="sidebar-label">Students</div>
        <div class="nav-item" id="nav-users" onclick="showSection('users',this)">
            <svg viewBox="0 0 16 16" fill="none"><circle cx="6" cy="5" r="2.2" stroke="currentColor" stroke-width="1.2"/><path d="M2 13c0-2.2 1.8-4 4-4s4 1.8 4 4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/><circle cx="12" cy="5" r="1.8" stroke="currentColor" stroke-width="1.2"/><path d="M13.5 13c0-1.8-1-3.3-2.5-3.8" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>Users
        </div>
        <div class="nav-item" id="nav-queries" onclick="showSection('queries',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M3 3h10a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" stroke="currentColor" stroke-width="1.2" fill="none"/></svg>Queries
        </div>
        <div class="nav-item" id="nav-feedbacks" onclick="showSection('feedbacks',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="currentColor" stroke-width="1.2" fill="none" stroke-linejoin="round"/></svg>Feedback
        </div>
        <div class="sidebar-label">Broadcast</div>
        <div class="nav-item" id="nav-announce" onclick="showSection('announce',this)">
            <svg viewBox="0 0 16 16" fill="none"><rect x="2" y="3" width="12" height="10" rx="1.5" stroke="currentColor" stroke-width="1.2" fill="none"/><path d="M5 7h6M5 10h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>Announcements
        </div>
        <div class="sidebar-label">Insights</div>
        <div class="nav-item" id="nav-analytics" onclick="showSection('analytics',this)">
            <svg viewBox="0 0 16 16" fill="none"><path d="M2 12L5 8L8 10L11 5L14 7" stroke="currentColor" stroke-width="1.3" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>Analytics
        </div>
    </div>

    <div class="content">
        <div class="hero">
            <div class="hero-bar"></div>
            <div class="hero-inner">
                <div class="big-av"><%= initials %></div>
                <div class="hero-info">
                    <div class="hero-name"><%= adminName %></div>
                    <div class="hero-sub">Administrator &nbsp;·&nbsp; Elective Recommendation System</div>
                    <div class="tags"><span class="tag tag-purple">Admin</span><span class="tag tag-red">Full Access</span><span class="tag tag-teal">Active Session</span></div>
                </div>
            </div>
        </div>

        <div class="stats-row">
            <div class="sc"><div class="sc-top" style="background:#534AB7"></div><div class="sc-icon" style="background:#EEEDFE"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="9" rx="1.5" stroke="#534AB7" stroke-width="1.4"/><path d="M5 4V3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1" stroke="#534AB7" stroke-width="1.4"/></svg></div><div class="sc-label">Electives</div><div class="sc-value"><%try{com.mongodb.client.MongoClient t1=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");out.print(t1.getDatabase("electiveDB").getCollection("electives").countDocuments());t1.close();}catch(Exception ex){out.print("—");}%></div><div class="sc-sub">total added</div></div>
            <div class="sc"><div class="sc-top" style="background:#1D9E75"></div><div class="sc-icon" style="background:#E1F5EE"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><circle cx="6" cy="5" r="2.2" stroke="#1D9E75" stroke-width="1.4"/><path d="M2 13c0-2.2 1.8-4 4-4s4 1.8 4 4" stroke="#1D9E75" stroke-width="1.4" stroke-linecap="round"/></svg></div><div class="sc-label">Students</div><div class="sc-value"><%try{com.mongodb.client.MongoClient t2=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");out.print(t2.getDatabase("electiveDB").getCollection("users").countDocuments(new Document("role","student")));t2.close();}catch(Exception ex){out.print("—");}%></div><div class="sc-sub">registered</div></div>
            <div class="sc"><div class="sc-top" style="background:#BA7517"></div><div class="sc-icon" style="background:#FAEEDA"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><path d="M3 3h10a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" stroke="#BA7517" stroke-width="1.4" fill="none"/></svg></div><div class="sc-label">Queries</div><div class="sc-value"><%try{com.mongodb.client.MongoClient t3=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");out.print(t3.getDatabase("electiveDB").getCollection("queries").countDocuments());t3.close();}catch(Exception ex){out.print("—");}%></div><div class="sc-sub">pending chats</div></div>
            <div class="sc"><div class="sc-top" style="background:#185FA5"></div><div class="sc-icon" style="background:#E6F1FB"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><path d="M2 12L5 8L8 10L11 5L14 7" stroke="#185FA5" stroke-width="1.4" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg></div><div class="sc-label">Selections</div><div class="sc-value"><%try{com.mongodb.client.MongoClient t4=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");out.print(t4.getDatabase("electiveDB").getCollection("selected_electives").countDocuments());t4.close();}catch(Exception ex){out.print("—");}%></div><div class="sc-sub">enrolled</div></div>
            <div class="sc"><div class="sc-top" style="background:#f59e0b"></div><div class="sc-icon" style="background:#FEF3C7"><svg width="14" height="14" viewBox="0 0 16 16" fill="none"><path d="M8 2L9.8 6.2H14L10.6 8.8 11.8 13 8 10.4 4.2 13 5.4 8.8 2 6.2H6.2Z" stroke="#B45309" stroke-width="1.2" fill="none" stroke-linejoin="round"/></svg></div><div class="sc-label">Feedback</div><div class="sc-value"><%try{com.mongodb.client.MongoClient t5=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");out.print(t5.getDatabase("electiveDB").getCollection("feedback").countDocuments());t5.close();}catch(Exception ex){out.print("—");}%></div><div class="sc-sub">reviews</div></div>
        </div>

        <div class="section-card">

            <!-- ADD -->
            <div id="add" class="section">
                <div class="section-head"><div><div class="section-title">Add New Elective</div><div class="section-sub">Fill in the details to add a new elective course</div></div><span class="badge">Admin Only</span></div>
                <div class="section-body"><form action="admin" method="post"><input type="hidden" name="action" value="add"><div class="form-grid"><div class="field" style="grid-column:span 2"><label>Elective Name</label><input type="text" name="name" placeholder="e.g. Machine Learning Fundamentals"></div><div class="field"><label>Category</label><select name="category"><option>AI</option><option>Web</option><option>Cyber</option><option>Data Science</option></select></div><div class="field"><label>Difficulty</label><select name="difficulty"><option>Easy</option><option>Medium</option><option>Hard</option></select></div><div class="field" style="grid-column:span 2"><label>Description</label><textarea name="description" rows="3" placeholder="Brief description..."></textarea></div></div><div style="display:flex;justify-content:flex-end;margin-top:16px;"><button type="submit" class="btn-primary">Add Elective</button></div></form></div>
            </div>

            <!-- DELETE -->
            <div id="delete" class="section">
                <div class="section-head"><div><div class="section-title">Delete Elective</div><div class="section-sub">Enter the exact elective name to remove it</div></div><span class="badge badge-red">Irreversible</span></div>
                <div class="section-body"><form action="admin" method="post"><input type="hidden" name="action" value="delete"><div class="form-grid"><div class="field" style="grid-column:span 2"><label>Elective Name</label><input type="text" name="name" placeholder="Enter exact elective name to delete"></div></div><div style="display:flex;justify-content:flex-end;margin-top:16px;"><button type="submit" class="btn-danger">Delete Elective</button></div></form></div>
            </div>

            <!-- LIST -->
            <div id="list" class="section">
                <div class="section-head"><div><div class="section-title">All Electives</div><div class="section-sub">All elective courses currently in the system</div></div><span class="badge badge-green">Live</span></div>
                <div class="section-body">
                <%List<Document> electives=(List<Document>)request.getAttribute("electives");if(electives!=null&&!electives.isEmpty()){for(Document e:electives){String diff=e.getString("difficulty")!=null?e.getString("difficulty"):"Easy";String pc="Easy".equals(diff)?"pill-easy":"Medium".equals(diff)?"pill-medium":"pill-hard";%>
                <div class="elective-card"><div><h3><%= e.getString("name") %></h3><p><%= e.getString("category")!=null?e.getString("category"):e.getString("domain") %></p></div><span class="pill <%= pc %>"><%= diff %></span></div>
                <%}}else{%><p style="color:#9ca3af;font-size:13px;">No electives found.</p><%}%>
                </div>
            </div>

            <!-- ═══ SYLLABUS UPLOAD ═══ -->
            <div id="syllabus" class="section">
                <div class="section-head">
                    <div><div class="section-title">Upload Syllabus PDF</div><div class="section-sub">Attach a PDF to any elective — students can view and download it inline</div></div>
                    <span class="badge">PDF only · Max 10 MB</span>
                </div>
                <div class="section-body">

                    <!-- Upload form -->
                    <div style="background:#f5f3ff;border:1px solid #AFA9EC;border-radius:12px;padding:20px;margin-bottom:24px">
                        <div style="font-size:12px;font-weight:700;color:#534AB7;text-transform:uppercase;letter-spacing:.05em;margin-bottom:14px">Upload New Syllabus</div>
                        <form action="syllabus" method="post" enctype="multipart/form-data" id="syllabusForm">
                            <div class="form-grid">
                                <div class="field" style="grid-column:span 2">
                                    <label>Select Elective</label>
                                    <select name="electiveName" required style="padding:9px 12px;border:1px solid #e0e0f0;border-radius:8px;font-size:13px;background:#fafafa;outline:none;font-family:inherit">
                                        <option value="">— Choose an elective —</option>
                                        <%try{com.mongodb.client.MongoClient selClient=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");com.mongodb.client.MongoCollection<Document> selCol=selClient.getDatabase("electiveDB").getCollection("electives");List<Document> selList=selCol.find().sort(new Document("name",1)).into(new java.util.ArrayList<>());for(Document se:selList){String seName=se.getString("name");String hasSyl=se.getString("syllabusFile")!=null?" ✓":"";%>
                                        <option value="<%= seName %>"><%= seName %><%= hasSyl %></option>
                                        <%}selClient.close();}catch(Exception ex){%><option disabled>Error loading</option><%}%>
                                    </select>
                                    <span style="font-size:11px;color:#9ca3af;margin-top:3px">✓ means syllabus already uploaded — uploading again will replace it</span>
                                </div>
                                <div class="field" style="grid-column:span 2">
                                    <label>PDF File</label>
                                    <div class="file-drop-zone" id="dropZone" onclick="document.getElementById('syllabusFile').click()">
                                        <div class="file-drop-icon">
                                            <svg viewBox="0 0 16 16" fill="none"><rect x="3" y="2" width="10" height="12" rx="1.5" stroke="#534AB7" stroke-width="1.3"/><path d="M8 5v5M6 8l2-2 2 2" stroke="#534AB7" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                        </div>
                                        <div id="dropText" style="font-size:13px;font-weight:600;color:#534AB7;margin-bottom:3px">Click to select PDF</div>
                                        <div style="font-size:11px;color:#9ca3af">or drag & drop here · PDF only · max 10 MB</div>
                                        <input type="file" name="syllabusFile" id="syllabusFile" accept="application/pdf" style="display:none" onchange="fileChosen(this)">
                                    </div>
                                </div>
                            </div>
                            <div style="display:flex;justify-content:flex-end;margin-top:16px">
                                <button type="submit" class="btn-primary" id="uploadBtn" disabled>Upload Syllabus</button>
                            </div>
                        </form>
                    </div>

                    <!-- Status table -->
                    <div class="section-divider">Syllabus Status — All Electives</div>
                    <table class="data-table">
                        <thead><tr><th>Elective</th><th>Domain</th><th>Syllabus</th><th>Preview</th></tr></thead>
                        <tbody>
                        <%try{com.mongodb.client.MongoClient stClient=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");com.mongodb.client.MongoCollection<Document> stCol=stClient.getDatabase("electiveDB").getCollection("electives");List<Document> stList=stCol.find().sort(new Document("name",1)).into(new java.util.ArrayList<>());for(Document st:stList){String stName=st.getString("name");String stDom=st.getString("domain")!=null?st.getString("domain"):st.getString("category");String stSyl=st.getString("syllabusFile");boolean hasSyl=stSyl!=null&&!stSyl.isEmpty();String encN=java.net.URLEncoder.encode(stName!=null?stName:"","UTF-8");%>
                        <tr>
                            <td><strong><%= stName %></strong></td>
                            <td><span style="font-size:11px;font-weight:600;color:#6b7280"><%= stDom %></span></td>
                            <td><%if(hasSyl){%><span style="display:inline-flex;align-items:center;gap:4px;background:#E1F5EE;color:#085041;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px"><svg width="10" height="10" viewBox="0 0 16 16" fill="none"><path d="M3 8l3 3 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>Uploaded</span><%}else{%><span style="display:inline-flex;align-items:center;gap:4px;background:#f1f0ef;color:#78716c;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px">Not uploaded</span><%}%></td>
                            <td><%if(hasSyl){%><a href="syllabus?electiveName=<%= encN %>" target="_blank" style="display:inline-flex;align-items:center;gap:4px;background:#EEEDFE;color:#534AB7;font-size:11px;font-weight:600;padding:4px 10px;border-radius:7px;text-decoration:none"><svg width="11" height="11" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><circle cx="8" cy="8" r="2" fill="currentColor"/></svg>View PDF</a><%}else{%><span style="font-size:11px;color:#c0c0d0">—</span><%}%></td>
                        </tr>
                        <%}stClient.close();}catch(Exception ex){out.println("<tr><td colspan='4' style='color:#E24B4A;font-size:13px;'>Error loading data.</td></tr>");}%>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- ═══ END SYLLABUS ═══ -->

            <!-- USERS -->
            <div id="users" class="section">
                <div class="section-head"><div><div class="section-title">Registered Users</div><div class="section-sub">All students in the system</div></div><form action="admin" method="get" style="display:inline"><input type="hidden" name="action" value="users"><button type="submit" class="btn-secondary">Refresh List</button></form></div>
                <div class="section-body">
                <%List<Document> users=(List<Document>)request.getAttribute("users");if(users!=null&&!users.isEmpty()){%>
                <table class="data-table"><thead><tr><th>Name</th><th>Student ID</th><th>Role</th></tr></thead><tbody>
                <%for(Document u:users){%><tr><td><strong><%= u.getString("name") %></strong></td><td style="color:#6b7280;font-family:monospace"><%= u.getString("studentId")!=null?u.getString("studentId"):"—" %></td><td><span class="pill <%= "admin".equals(u.getString("role"))?"pill-medium":"pill-easy" %>"><%= u.getString("role")!=null?u.getString("role"):"student" %></span></td></tr><%}%>
                </tbody></table>
                <%}else{%><p style="color:#9ca3af;font-size:13px;">Click "Refresh List" to load users.</p><%}%>
                </div>
            </div>

            <!-- QUERIES -->
            <div id="queries" class="section">
                <div class="section-head"><div><div class="section-title">Student Queries</div><div class="section-sub">Chat thread with students — reply below</div></div></div>
                <div class="section-body">
                <%try{com.mongodb.client.MongoClient qclient=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");com.mongodb.client.MongoCollection<Document> qcol=qclient.getDatabase("electiveDB").getCollection("queries");List<Document> qlist=qcol.find().into(new java.util.ArrayList<>());if(qlist.isEmpty()){%><p style="color:#9ca3af;font-size:13px;">No queries yet.</p><%}else{for(Document q:qlist){List<Document> messages=(List<Document>)q.get("messages");%>
                <div class="query-block"><div class="query-block-head"><svg width="13" height="13" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5.5" r="2.5" stroke="#534AB7" stroke-width="1.3"/><path d="M3 14c0-2.76 2.24-5 5-5s5 2.24 5 5" stroke="#534AB7" stroke-width="1.3" stroke-linecap="round"/></svg><span class="query-sid">Student ID: <%= q.getString("studentId") %></span></div>
                <div class="chat-window"><%if(messages!=null){for(Document m:messages){String sender=m.getString("sender");String text=m.getString("text");boolean isAdm="admin".equals(sender);%><div class="msg <%= isAdm?"admin-msg":"student" %>"><div class="bubble"><div class="sender"><%= sender %></div><%= text %></div></div><%}}else{%><div class="msg student"><div class="bubble"><div class="sender">student</div><%= q.getString("query")!=null?q.getString("query"):"" %></div></div><%}%></div>
                <form action="answer" method="post" class="reply-form"><input type="hidden" name="studentId" value="<%= q.getString("studentId") %>"><input type="text" name="answer" placeholder="Type your reply..."><button type="submit" class="btn-success">Send</button></form></div>
                <%}}qclient.close();}catch(Exception ex){out.println("<p style='color:#E24B4A;font-size:13px;'>Error loading queries.</p>");}%>
                </div>
            </div>

            <!-- FEEDBACK -->
            <div id="feedbacks" class="section">
                <div class="section-head"><div><div class="section-title">Student Feedback</div><div class="section-sub">Star ratings and reviews for enrolled electives</div></div><span class="badge badge-amber">Student Reviews</span></div>
                <div class="section-body">
                <%try{com.mongodb.client.MongoClient fbClient=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");com.mongodb.client.MongoCollection<Document> fbCol=fbClient.getDatabase("electiveDB").getCollection("feedback");List<Document> allFeedback=fbCol.find().into(new java.util.ArrayList<>());if(allFeedback.isEmpty()){%><div style="text-align:center;padding:36px 0"><div style="font-size:14px;font-weight:700;color:#1a1a2e;margin-bottom:5px">No feedback received yet</div></div>
                <%}else{java.util.Map<String,int[]> summary=new java.util.LinkedHashMap<>();for(Document fb:allFeedback){String eName=fb.getString("electiveName");int rat=fb.getInteger("rating",0);if(eName==null)continue;summary.putIfAbsent(eName,new int[]{0,0});summary.get(eName)[0]+=rat;summary.get(eName)[1]++;}%>
                <div class="fb-summary-grid"><%for(Map.Entry<String,int[]> e:summary.entrySet()){double avg=(double)e.getValue()[0]/e.getValue()[1];int fs=(int)Math.round(avg);%><div class="fb-summary-card"><div class="fb-summary-name" title="<%= e.getKey() %>"><%= e.getKey() %></div><div class="fb-stars-disp"><%for(int s=1;s<=5;s++){%><%= s<=fs?"★":"☆" %><%}%></div><div class="fb-meta">Avg <%= String.format("%.1f",avg) %>/5 &nbsp;·&nbsp; <%= e.getValue()[1] %> review<%= e.getValue()[1]>1?"s":"" %></div></div><%}%></div>
                <div class="section-divider">All Individual Reviews</div>
                <table class="data-table"><thead><tr><th>Student</th><th>ID</th><th>Elective</th><th>Rating</th><th>Comment</th><th>Submitted</th></tr></thead><tbody>
                <%for(Document fb:allFeedback){int r=fb.getInteger("rating",0);String cmt=fb.getString("comment");%><tr><td><strong><%= fb.getString("studentName")!=null?fb.getString("studentName"):"—" %></strong></td><td style="color:#6b7280;font-family:monospace;font-size:12px"><%= fb.getString("studentId") %></td><td><span style="background:#EEEDFE;color:#3C3489;font-size:11px;font-weight:600;padding:2px 9px;border-radius:20px"><%= fb.getString("electiveName") %></span></td><td style="color:#f59e0b;font-size:15px;letter-spacing:1px;white-space:nowrap"><%for(int s=1;s<=5;s++){%><%= s<=r?"★":"☆" %><%}%><span style="font-size:11px;color:#9ca3af;font-family:sans-serif"> (<%= r %>/5)</span></td><td style="color:#6b7280;font-size:12px;max-width:200px"><%= (cmt!=null&&!cmt.isEmpty())?cmt:"<span style='color:#c0c0d0'>No comment</span>" %></td><td style="color:#c0c0d0;font-size:11px;white-space:nowrap"><%= fb.getString("timestamp") %></td></tr><%}%>
                </tbody></table><%}fbClient.close();}catch(Exception ex){out.println("<p style='color:#E24B4A;font-size:13px;'>Error loading feedback.</p>");}%>
                </div>
            </div>

            <!-- ANNOUNCEMENTS -->
            <div id="announce" class="section">
                <div class="section-head"><div><div class="section-title">Announcements</div><div class="section-sub">Post notices to all students — they see them on their dashboard instantly</div></div><span class="badge badge-green">Broadcasts to all students</span></div>
                <div class="section-body">
                    <div style="background:#f5f3ff;border:1px solid #AFA9EC;border-radius:12px;padding:20px;margin-bottom:22px">
                        <div style="font-size:12px;font-weight:700;color:#534AB7;text-transform:uppercase;letter-spacing:.05em;margin-bottom:14px">Post New Announcement</div>
                        <form action="announcement" method="post"><input type="hidden" name="type" id="typeInput" value="info">
                            <div class="form-grid" style="margin-bottom:14px">
                                <div class="field" style="grid-column:span 2"><label>Title</label><input type="text" name="title" placeholder="e.g. Elective enrollment opens Monday"></div>
                                <div class="field" style="grid-column:span 2"><label>Message</label><textarea name="message" rows="3" placeholder="Write your announcement here..."></textarea></div>
                                <div class="field" style="grid-column:span 2"><label>Type</label><div class="type-grid"><div class="type-btn sel-info" id="type-info" onclick="setType('info')">ℹ Info</div><div class="type-btn" id="type-warning" onclick="setType('warning')">⚠ Warning</div><div class="type-btn" id="type-success" onclick="setType('success')">✓ Success</div></div></div>
                            </div>
                            <div style="display:flex;justify-content:flex-end"><button type="submit" class="btn-primary">Post Announcement</button></div>
                        </form>
                    </div>
                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;letter-spacing:.05em;margin-bottom:12px">Posted Announcements</div>
                    <%try{com.mongodb.client.MongoClient annClient=com.mongodb.client.MongoClients.create("mongodb://localhost:27017");com.mongodb.client.MongoCollection<Document> annCol=annClient.getDatabase("electiveDB").getCollection("announcements");List<Document> annList=annCol.find().sort(new Document("_id",-1)).into(new java.util.ArrayList<>());if(annList.isEmpty()){%><p style="color:#9ca3af;font-size:13px;">No announcements posted yet.</p>
                    <%}else{for(Document ann:annList){String atype=ann.getString("type")!=null?ann.getString("type"):"info";String annId=ann.getObjectId("_id").toHexString();boolean isActive=Boolean.TRUE.equals(ann.getBoolean("active"));%>
                    <div class="ann-card <%= atype %>" id="ann-<%= annId %>">
                        <div class="ann-card-icon"><%if("warning".equals(atype)){%><svg viewBox="0 0 16 16" fill="none"><path d="M8 3L14 13H2L8 3z" stroke="#CA8A04" stroke-width="1.3" fill="none" stroke-linejoin="round"/><path d="M8 7v3M8 11.5v.5" stroke="#CA8A04" stroke-width="1.3" stroke-linecap="round"/></svg><%}else if("success".equals(atype)){%><svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="5.5" stroke="#1D9E75" stroke-width="1.3"/><path d="M5.5 8l2 2 3-3" stroke="#1D9E75" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg><%}else{%><svg viewBox="0 0 16 16" fill="none"><rect x="2" y="3" width="12" height="10" rx="1.5" stroke="#534AB7" stroke-width="1.3" fill="none"/><path d="M5 7h6M5 10h4" stroke="#534AB7" stroke-width="1.2" stroke-linecap="round"/></svg><%}%></div>
                        <div class="ann-card-body"><div class="ann-card-title"><%= ann.getString("title") %></div><div class="ann-card-msg"><%= ann.getString("message") %></div><div class="ann-card-meta">Posted by <%= ann.getString("postedBy") %> &nbsp;·&nbsp; <%= ann.getString("timestamp")!=null?ann.getString("timestamp").substring(0,24):"" %> &nbsp;·&nbsp; <span style="color:<%= isActive?"#1D9E75":"#9ca3af" %>;font-weight:600"><%= isActive?"Active":"Hidden" %></span></div></div>
                        <div style="flex-shrink:0"><button class="btn-sm-red" onclick="deleteAnn('<%= annId %>')">Delete</button></div>
                    </div>
                    <%}}annClient.close();}catch(Exception ex){out.println("<p style='color:#E24B4A;font-size:13px;'>Error loading announcements.</p>");}%>
                </div>
            </div>

            <!-- ANALYTICS -->
            <div id="analytics" class="section">
                <div class="section-head"><div><div class="section-title">Analytics Overview</div><div class="section-sub">System-wide academic and usage stats</div></div><span class="badge badge-green">Live Data</span></div>
                <div class="section-body">
                    <div class="charts-grid">
                        <div class="chart-box"><canvas id="cgpaChart"></canvas></div>
                        <div class="chart-box"><canvas id="codingChart"></canvas></div>
                        <div class="chart-box"><canvas id="radarChart"></canvas></div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
let chartsLoaded = false;
function showSection(id, el) {
    document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    if (el) el.classList.add('active');
    if (id === 'analytics' && !chartsLoaded) { loadCharts(); chartsLoaded = true; }
    if (id === 'queries') document.querySelectorAll('.chat-window').forEach(cw => setTimeout(() => cw.scrollTop = cw.scrollHeight, 50));
}
(function () {
    const sec = '<%= openSec %>';
    const navEl = document.getElementById('nav-' + sec);
    if (document.getElementById(sec)) showSection(sec, navEl);
    else showSection('add', document.getElementById('nav-add'));
})();
(function () {
    const show = <%= justSaved || hasError %>;
    if (!show) return;
    const t = document.getElementById('toast');
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 3500);
    history.replaceState(null, '', window.location.pathname);
})();
function setType(type) {
    document.getElementById('typeInput').value = type;
    ['info','warning','success'].forEach(t => { const btn = document.getElementById('type-'+t); btn.className = 'type-btn' + (t===type?' sel-'+t:''); });
}
function deleteAnn(id) {
    if (!confirm('Delete this announcement? Students will no longer see it.')) return;
    fetch('announcement?id=' + id, { method: 'DELETE' }).then(r => {
        if (r.ok) { const el = document.getElementById('ann-'+id); if (el) { el.style.opacity='0'; el.style.transition='opacity .3s'; setTimeout(()=>el.remove(),300); } }
        else alert('Could not delete. Please try again.');
    });
}
/* Syllabus upload */
function fileChosen(input) {
    const file = input.files[0];
    const dropText = document.getElementById('dropText');
    const uploadBtn = document.getElementById('uploadBtn');
    const dropZone  = document.getElementById('dropZone');
    if (file) {
        if (file.type !== 'application/pdf') { alert('Please select a PDF file only.'); input.value=''; return; }
        if (file.size > 10*1024*1024) { alert('File too large. Maximum 10 MB.'); input.value=''; return; }
        dropText.textContent = '📄 ' + file.name + ' (' + (file.size/1024).toFixed(0) + ' KB)';
        dropText.style.color = '#1D9E75';
        dropZone.style.borderColor = '#1D9E75';
        uploadBtn.disabled = false;
    }
}
(function(){
    const dz = document.getElementById('dropZone');
    if (!dz) return;
    dz.addEventListener('dragover', e => { e.preventDefault(); dz.classList.add('dragover'); });
    dz.addEventListener('dragleave', () => dz.classList.remove('dragover'));
    dz.addEventListener('drop', e => {
        e.preventDefault(); dz.classList.remove('dragover');
        const file = e.dataTransfer.files[0];
        if (file) { const inp = document.getElementById('syllabusFile'); const dt = new DataTransfer(); dt.items.add(file); inp.files = dt.files; fileChosen(inp); }
    });
})();
function loadCharts() {
    new Chart(document.getElementById('cgpaChart'),{type:'bar',data:{labels:['6-7','7-8','8-9','9-10'],datasets:[{label:'Students',data:[4,12,18,7],backgroundColor:['#AFA9EC','#7F77DD','#534AB7','#3C3489'],borderRadius:6,borderSkipped:false}]},options:{responsive:true,plugins:{legend:{display:false},title:{display:true,text:'CGPA Distribution',font:{size:13,weight:'600'}}},scales:{y:{beginAtZero:true,grid:{color:'#f0f0f8'}},x:{grid:{display:false}}}}});
    new Chart(document.getElementById('codingChart'),{type:'doughnut',data:{labels:['Beginner','Intermediate','Advanced'],datasets:[{data:[15,22,8],backgroundColor:['#AFA9EC','#534AB7','#3C3489'],borderWidth:2,borderColor:'#fff'}]},options:{responsive:true,plugins:{legend:{position:'bottom',labels:{boxWidth:12,font:{size:11}}},title:{display:true,text:'Coding Level Split',font:{size:13,weight:'600'}}}}});
    new Chart(document.getElementById('radarChart'),{type:'radar',data:{labels:['Academics','Coding','Goal','Consistency','Growth'],datasets:[{label:'Avg Score',data:[8,7,9,7,8],borderColor:'#534AB7',backgroundColor:'rgba(83,74,183,0.15)',pointBackgroundColor:'#534AB7'}]},options:{responsive:true,plugins:{legend:{display:false},title:{display:true,text:'Student Performance Radar',font:{size:13,weight:'600'}}},scales:{r:{beginAtZero:true,max:10,grid:{color:'#e8e8f0'}}}}});
}
</script>
</body>
</html>
