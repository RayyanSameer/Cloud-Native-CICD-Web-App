import { useState, useEffect, useRef } from "react";

// ─── PALETTE ────────────────────────────────────────────────────────────────
const C = {
  bg:          "#0e0f0d",
  bgAlt:       "#121310",
  surface:     "#191b17",
  border:      "#252721",
  borderHi:    "#363830",

  fg:          "#edecea",
  fgMid:       "#888882",
  fgDim:       "#484942",

  accent:      "#E8B86D",   // amber gold — AAA contrast, split-complementary
  accentMid:   "#B88A45",
  accentBg:    "#1e1608",   // darker so accent tags aren't too heavy
  accentBorder:"#3a2c14",

  live:        "#7dc98a",
  liveBg:      "#192d1e",
  prog:        "#c4924a",   // desaturated ochre — distinct from accent, not amber
  progBg:      "#241a0a",
  progBorder:  "#3a2a10",
};

// ─── DATA ────────────────────────────────────────────────────────────────────
const builds = [
  { num:"01", title:"AWS Native CI/CD Pipeline",   status:"Live",        tags:["CodePipeline","CodeBuild","S3","IAM"],        desc:"End-to-end automated deployment pipeline using native AWS developer tools. Source to production, zero manual intervention.",                              github:"https://github.com/RayyanSameer" },
  { num:"02", title:"AWS EKS 3-Tier App",          status:"Live",        tags:["EKS","Kubernetes","RDS","ALB"],               desc:"Production-grade three-tier architecture on Elastic Kubernetes Service with managed node groups, auto-scaling, and load balancing.",                   github:"https://github.com/RayyanSameer" },
  { num:"03", title:"Serverless Data Retrieval",   status:"Live",        tags:["Lambda","API Gateway","DynamoDB","S3"],       desc:"Fully event-driven data pipeline. Serverless Lambda functions doing the heavy lifting — scalable, cost-effective, and fast.",                           github:"https://github.com/RayyanSameer" },
  { num:"04", title:"AWS Cost Optimizer",          status:"Live",        tags:["Cost Explorer","Lambda","CloudWatch","SNS"],  desc:"Intelligent cost analysis tool that surfaces unused resources and delivers actionable savings recommendations automatically.",                            github:"https://github.com/RayyanSameer" },
  { num:"05", title:"Kubernetes Observation Tool", status:"In Progress", tags:["Prometheus","Grafana","Helm","K8s"],          desc:"Real-time cluster observability  metrics, logs, and alerting unified. One pane of glass for everything running on K8s.",                               github:"https://github.com/RayyanSameer" },
  { num:"06", title:"Serverless Chat App",         status:"In Progress", tags:["WebSocket","API Gateway","Lambda","DynamoDB"],desc:"Real-time chat powered by WebSocket APIs and persistent DynamoDB storage. Scales to zero, scales to millions.",                                     github:"https://github.com/RayyanSameer" },
  { num:"07", title:"Cloud Content & Blog",        status:"Coming Soon", tags:["Instagram","Blog","Content"],                 desc:"Architecture breakdowns, build walkthroughs, and cloud insights  shared as visual content and long-form writing.",                                     github:null, comingSoon: true },
];

const skills = ["AWS","Kubernetes","Docker","Terraform","CI/CD","EKS","Lambda","Serverless","Python","Node.js","Prometheus","Grafana","Linux","CloudFormation","Git"];

// Cloud service icons for the about box visual
const cloudIcons = [
  { label:"EC2",        icon:"⚙️" },
  { label:"Lambda",     icon:"λ" },
  { label:"EKS",        icon:"☸" },
  { label:"S3",         icon:"🗄" },
  { label:"RDS",        icon:"🛢" },
  { label:"CloudWatch", icon:"◉" },
  { label:"IAM",        icon:"🔐" },
  { label:"VPC",        icon:"🔲" },
  { label:"API GW",     icon:"⇄" },
];

// ─── HOOKS ────────────────────────────────────────────────────────────────────
function useInView(threshold = 0.12) {
  const ref = useRef(null);
  const [inView, setInView] = useState(false);
  useEffect(() => {
    const obs = new IntersectionObserver(([e]) => { if (e.isIntersecting) setInView(true); }, { threshold });
    if (ref.current) obs.observe(ref.current);
    return () => obs.disconnect();
  }, []);
  return [ref, inView];
}

function useScrollProgress() {
  const [pct, setPct] = useState(0);
  useEffect(() => {
    const onScroll = () => {
      const doc = document.documentElement;
      const total = doc.scrollHeight - doc.clientHeight;
      setPct(total > 0 ? (window.scrollY / total) * 100 : 0);
    };
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);
  return pct;
}

// ─── COMPONENTS ──────────────────────────────────────────────────────────────
function Reveal({ children, delay = 0, style = {} }) {
  const [ref, inView] = useInView();
  return (
    <div ref={ref} style={{
      opacity: inView ? 1 : 0,
      transform: inView ? "translateY(0)" : "translateY(28px)",
      transition: `opacity 0.75s ease ${delay}s, transform 0.75s ease ${delay}s`,
      ...style,
    }}>{children}</div>
  );
}

function Marquee() {
  const items = ["AWS · ","Kubernetes · ","Serverless · ","EKS · ","CI/CD · ","Cloud Engineering · ","DevOps · ","Infrastructure · "];
  const [paused, setPaused] = useState(false);
  return (
    <div
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      style={{ overflow:"hidden", borderTop:`1px solid ${C.border}`, borderBottom:`1px solid ${C.border}`, padding:"13px 0", cursor:"default" }}
    >
      <div style={{ display:"flex", animation:`marquee 28s linear infinite`, animationPlayState: paused ? "paused" : "running", whiteSpace:"nowrap" }}>
        {[...items,...items,...items].map((t,i) => (
          <span key={i} style={{ fontFamily:"'Playfair Display',serif", fontStyle:"italic", fontSize:13, color: paused ? C.fgMid : C.fgDim, letterSpacing:2, transition:"color 0.3s" }}>{t}</span>
        ))}
      </div>
    </div>
  );
}

// About visual — AWS architecture diagram
function AboutVisual() {
  const [activeNode, setActiveNode] = useState(null);
  const nodes = [
    { id:"user",   label:"User",      x:50,  y:10,  icon:"👤" },
    { id:"cdn",    label:"CloudFront",x:50,  y:28,  icon:"⚡" },
    { id:"alb",    label:"ALB",       x:50,  y:46,  icon:"⇄"  },
    { id:"eks",    label:"EKS",       x:20,  y:64,  icon:"☸"  },
    { id:"lambda", label:"Lambda",    x:50,  y:64,  icon:"λ"  },
    { id:"rds",    label:"RDS",       x:80,  y:64,  icon:"🛢"  },
    { id:"s3",     label:"S3",        x:20,  y:82,  icon:"🗄"  },
    { id:"cw",     label:"CloudWatch",x:50,  y:82,  icon:"◉"  },
    { id:"iam",    label:"IAM",       x:80,  y:82,  icon:"🔐"  },
  ];
  const edges = [
    ["user","cdn"],["cdn","alb"],["alb","eks"],["alb","lambda"],["alb","rds"],
    ["eks","s3"],["lambda","cw"],["rds","iam"],
  ];
  return (
    <div style={{ position:"relative", width:"100%", height:"100%", padding:"24px" }}>
      <svg style={{ position:"absolute", inset:0, width:"100%", height:"100%", pointerEvents:"none" }}>
        {edges.map(([a,b],i) => {
          const A = nodes.find(n=>n.id===a), B = nodes.find(n=>n.id===b);
          const isActive = activeNode === a || activeNode === b;
          return (
            <line key={i}
              x1={`${A.x}%`} y1={`${A.y + 4}%`}
              x2={`${B.x}%`} y2={`${B.y - 4}%`}
              stroke={isActive ? C.accent : C.border}
              strokeWidth={isActive ? 1.5 : 1}
              strokeDasharray={isActive ? "none" : "4 4"}
              style={{ transition:"all 0.3s" }}
            />
          );
        })}
      </svg>
      {nodes.map(n => (
        <div key={n.id}
          onMouseEnter={() => setActiveNode(n.id)}
          onMouseLeave={() => setActiveNode(null)}
          style={{
            position:"absolute",
            left:`${n.x}%`, top:`${n.y}%`,
            transform:"translate(-50%,-50%)",
            display:"flex", flexDirection:"column", alignItems:"center", gap:4,
            cursor:"default",
          }}
        >
          <div style={{
            width:44, height:44,
            background: activeNode === n.id ? C.accentBg : C.bg,
            border:`1px solid ${activeNode === n.id ? C.accent : C.border}`,
            display:"flex", alignItems:"center", justifyContent:"center",
            fontSize:18, transition:"all 0.25s",
            boxShadow: activeNode === n.id ? `0 0 16px ${C.accentBg}` : "none",
          }}>
            {n.icon}
          </div>
          <span style={{
            fontSize:9, letterSpacing:1, textTransform:"uppercase",
            color: activeNode === n.id ? C.accent : C.fgDim,
            fontFamily:"'DM Sans',sans-serif", transition:"color 0.25s",
            whiteSpace:"nowrap",
          }}>{n.label}</span>
        </div>
      ))}
    </div>
  );
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────
export default function Portfolio() {
  const [hovered, setHovered] = useState(null);
  const scrollPct = useScrollProgress();

  return (
    <div style={{ background:C.bg, color:C.fg, minHeight:"100vh", fontFamily:"'DM Sans',sans-serif", overflowX:"hidden" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400;1,700&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap');
        *{ box-sizing:border-box; margin:0; padding:0; }
        ::selection{ background:${C.accentBg}; color:${C.accent}; }
        html{ scroll-behavior:smooth; }

        @keyframes marquee{ from{transform:translateX(0)} to{transform:translateX(-33.33%)} }
        @keyframes fadeUp{ from{opacity:0;transform:translateY(40px)} to{opacity:1;transform:translateY(0)} }
        @keyframes pulse{ 0%,100%{opacity:1} 50%{opacity:0.4} }

        /* ── SCROLL PROGRESS ── */
        .scroll-bar{
          position:fixed;top:0;left:0;height:2px;z-index:200;
          background:${C.accent};
          transition:width 0.1s linear;
          box-shadow:0 0 8px ${C.accent}66;
        }

        /* ── NAV ── */
        .nav{
          position:fixed;top:0;left:0;right:0;z-index:100;
          display:flex;justify-content:space-between;align-items:center;
          padding:22px 52px;
          background:rgba(14,15,13,0.92);
          backdrop-filter:blur(16px);
          border-bottom:1px solid ${C.border};
        }
        .nav-logo{
          font-family:'Playfair Display',serif;font-style:italic;
          font-size:16px;color:${C.fg};letter-spacing:0.5px;
        }
        .nav-links{display:flex;gap:40px;list-style:none;}
        .nav-links a{
          font-size:11px;color:${C.fgMid};text-decoration:none;
          letter-spacing:2.5px;text-transform:uppercase;transition:color 0.2s;
        }
        .nav-links a:hover{ color:${C.accent}; }
        .nav-cta{
          font-size:11px;letter-spacing:2px;text-transform:uppercase;
          color:${C.accent};text-decoration:none;
          border-bottom:1px solid ${C.accentBorder};padding-bottom:2px;
          transition:border-color 0.2s, color 0.2s;
        }
        .nav-cta:hover{ border-color:${C.accent}; color:${C.accentMid}; }

        /* ── HERO ── */
        .hero{ padding:178px 52px 88px; }
        .eyebrow{
          font-size:11px;letter-spacing:4px;text-transform:uppercase;
          color:${C.fgDim};margin-bottom:40px;
          display:flex;align-items:center;gap:14px;
        }
        .eyebrow::before{content:'';width:28px;height:1px;background:${C.fgDim};display:block;}

        .name-solid{
          font-family:'Playfair Display',serif;
          font-size:clamp(72px,11vw,150px);font-weight:900;letter-spacing:-4px;
          display:block;color:${C.fg};
          animation:fadeUp 0.9s ease forwards;opacity:0;
        }
        .name-outline{
          font-family:'Playfair Display',serif;
          font-size:clamp(72px,11vw,150px);font-weight:900;letter-spacing:-4px;
          display:block;color:transparent;
          -webkit-text-stroke:1.5px ${C.accent};
          animation:fadeUp 0.9s ease 0.15s forwards;opacity:0;
        }
        /* FIX #5 — subtitle at ~60% of name size, more separation */
        .name-sub{
          font-family:'Playfair Display',serif;
          font-size:clamp(20px,4.5vw,68px);font-weight:400;font-style:italic;
          letter-spacing:-2px;display:block;color:${C.fgDim};margin-top:24px;
          animation:fadeUp 0.9s ease 0.28s forwards;opacity:0;
        }
        /* FIX #6 — hero desc anchored with top border rule */
        .hero-bottom{
          display:flex;justify-content:space-between;align-items:flex-end;
          gap:40px;margin-top:56px;flex-wrap:wrap;
          padding-top:40px;border-top:1px solid ${C.border};
        }
        .hero-desc{
          max-width:420px;font-size:16px;line-height:1.8;
          color:${C.fgMid};font-weight:300;
          animation:fadeUp 0.9s ease 0.4s forwards;opacity:0;
        }
        .hero-cta{
          display:flex;flex-direction:column;align-items:flex-end;gap:14px;
          animation:fadeUp 0.9s ease 0.5s forwards;opacity:0;
        }
        /* FIX #12 — paren moved, just a personality note not a button label */
        .paren{
          font-family:'Playfair Display',serif;font-style:italic;
          font-size:13px;color:${C.fgDim};
          animation:fadeUp 0.9s ease 0.2s forwards;opacity:0;
          margin-bottom: 4px;
        }

        /* ── BUTTONS ── */
        .btn-main{
          display:inline-block;text-decoration:none;
          font-size:11px;letter-spacing:2.5px;text-transform:uppercase;
          color:${C.bg};background:${C.accent};
          padding:15px 36px;transition:all 0.22s;border:none;cursor:pointer;
        }
        .btn-main:hover{ background:${C.accentMid}; transform:translateY(-2px); }
        .btn-main:active{ transform:translateY(0); background:${C.accentMid}; filter:brightness(0.9); }
        .btn-outline{
          display:inline-block;text-decoration:none;
          font-size:11px;letter-spacing:2.5px;text-transform:uppercase;
          color:${C.fgMid};background:transparent;
          padding:15px 36px;border:1px solid ${C.border};transition:all 0.22s;
        }
        .btn-outline:hover{ border-color:${C.fgMid}; color:${C.fg}; }
        .btn-outline:active{ filter:brightness(0.85); }

        /* ── SECTIONS ── */
        .section{ padding:96px 52px; max-width:1400px; margin:0 auto; }

        /* FIX #7 — each section title has unique styling */
        .sec-title{
          font-family:'Playfair Display',serif;
          font-size:clamp(38px,5vw,62px);font-weight:700;
          letter-spacing:-2px;line-height:1.04;
          color:${C.fg};margin-bottom:16px;
        }
        /* FIX #13 — intro line below title */
        .sec-intro{
          font-size:14px;color:${C.fgDim};letter-spacing:0.5px;
          margin-bottom:52px;font-style:italic;
          font-family:'Playfair Display',serif;
        }
        .sec-intro span{ color:${C.accent}; }

        /* ── BUILDS ── */
        .builds-list{ border-top:1px solid ${C.border}; }
        .build-row{
          display:grid;grid-template-columns:72px 1fr 132px;
          gap:36px;align-items:start;
          padding:36px 0;border-bottom:1px solid ${C.border};
          transition:background 0.25s;
          border-radius:2px;
        }
        /* FIX #9 — removed the margin trick that breaks on mobile */
        .build-row:hover{ background:${C.surface}; padding-left:16px; padding-right:16px; margin-left:-16px; margin-right:-16px; }
        .build-num{
          font-family:'Playfair Display',serif;font-style:italic;
          font-size:13px;color:${C.fgDim};padding-top:4px;
        }
        .build-title{
          font-family:'Playfair Display',serif;
          font-size:clamp(22px,2.8vw,36px);font-weight:700;
          letter-spacing:-0.8px;line-height:1.1;margin-bottom:10px;
          transition:color 0.3s;
        }
        .build-desc{
          font-size:14px;color:${C.fgMid};line-height:1.75;
          max-width:560px;margin-bottom:18px;font-weight:300;
        }
        .tags-row{ display:flex;flex-wrap:wrap;gap:8px; }
        /* FIX #1 — tags are muted by default, amber only on hover */
        .tag{
          font-size:10px;letter-spacing:1.5px;text-transform:uppercase;
          color:${C.fgDim};background:transparent;
          border:1px solid ${C.border};padding:4px 10px;
          transition:all 0.18s;cursor:default;
        }
        .tag:hover{ color:${C.accent};border-color:${C.accentBorder};background:${C.accentBg}; }
        .build-link{
          display:inline-block;margin-top:14px;
          font-size:11px;letter-spacing:2px;text-transform:uppercase;
          color:${C.accent};text-decoration:none;
          border-bottom:1px solid ${C.accentBorder};padding-bottom:1px;
          transition:border-color 0.2s,color 0.2s;
        }
        .build-link:hover{ border-color:${C.accent};color:${C.accentMid}; }
        /* FIX #14 — coming soon placeholder link */
        .build-soon-link{
          display:inline-block;margin-top:14px;
          font-size:11px;letter-spacing:2px;text-transform:uppercase;
          color:${C.fgDim};text-decoration:none;
          border-bottom:1px solid ${C.border};padding-bottom:1px;
          cursor:default;
        }
        .status-col{ text-align:right;padding-top:5px; }
        .badge{ display:inline-block;font-size:10px;letter-spacing:1.5px;text-transform:uppercase;padding:5px 11px; }
        .s-live{ color:${C.live};background:${C.liveBg}; }
        /* FIX #2 — in-progress uses distinct ochre, not same amber as accent */
        .s-prog{ color:${C.prog};background:${C.progBg};border:1px solid ${C.progBorder}; }
        .s-soon{ color:${C.fgDim};background:${C.surface};border:1px solid ${C.border}; }

        /* ── ABOUT ── */
        .about-section-title{
          font-family:'Playfair Display',serif;
          font-size:clamp(38px,5vw,62px);font-weight:700;
          letter-spacing:-2px;line-height:1.04;
          color:${C.fg};margin-bottom:60px;
          font-style:italic;
        }
        .about-grid{ display:grid;grid-template-columns:1fr 1fr;gap:80px;align-items:start; }
        .about-quote{
          font-family:'Playfair Display',serif;
          font-size:clamp(20px,2.4vw,26px);line-height:1.7;
          color:${C.fg};font-weight:400;margin-bottom:28px;
          border-left:2px solid ${C.accent};padding-left:20px;
        }
        .about-body{ font-size:15px;color:${C.fgMid};line-height:1.85;font-weight:300;margin-bottom:18px; }
        /* FIX #8 — replaced empty box with AWS architecture diagram */
        .about-box{
          position:relative;height:520px;
          background:${C.bgAlt};border:1px solid ${C.border};
          overflow:hidden;
        }
        .about-box-label{
          position:absolute;bottom:16px;left:50%;transform:translateX(-50%);
          font-size:9px;letter-spacing:3px;text-transform:uppercase;color:${C.fgDim};
          white-space:nowrap;
        }
        .about-box-title{
          position:absolute;top:16px;left:20px;
          font-size:9px;letter-spacing:3px;text-transform:uppercase;color:${C.fgDim};
        }

        /* FIX #1 / #11 — skills are muted by default, amber on hover */
        .skills-wrap{ display:flex;flex-wrap:wrap;gap:10px; }
        .skill{
          font-size:12px;letter-spacing:0.5px;color:${C.fgMid};
          border:1px solid ${C.border};background:transparent;
          padding:9px 20px;transition:all 0.18s;cursor:default;font-weight:300;
        }
        .skill:hover{ background:${C.accent};color:${C.bg};border-color:${C.accent}; }

        /* ── CONTACT ── */
        /* FIX #11 — reduced padding */
        .contact-wrap{ padding:72px 52px 80px;border-top:1px solid ${C.border};max-width:1400px;margin:0 auto; }
        /* FIX #7 — contact title is distinct: larger, line-break styled differently */
        .contact-big{
          font-family:'Playfair Display',serif;
          font-size:clamp(48px,8vw,112px);font-weight:900;
          letter-spacing:-4px;line-height:0.9;color:${C.fg};margin-bottom:48px;
        }
        .contact-big .amber{ color:${C.accent}; -webkit-text-stroke:0; }
        .contact-row{ display:flex;gap:16px;flex-wrap:wrap;margin-bottom:72px; }
        .contact-link{
          display:flex;align-items:center;gap:10px;text-decoration:none;
          font-size:11px;letter-spacing:2px;text-transform:uppercase;
          color:${C.fgMid};padding:16px 28px;border:1px solid ${C.border};
          transition:all 0.22s;
        }
        .contact-link:hover{ color:${C.accent};border-color:${C.accentBorder};background:${C.accentBg}; }
        .contact-link:active{ filter:brightness(0.85); }

        /* ── FOOTER ── */
        .footer-bar{
          display:flex;justify-content:space-between;align-items:center;
          padding-top:32px;border-top:1px solid ${C.border};
          font-size:10px;letter-spacing:2px;text-transform:uppercase;color:${C.fgDim};
        }
        .footer-bar a{ color:${C.fgDim};text-decoration:none;transition:color 0.2s; }
        .footer-bar a:hover{ color:${C.accent}; }
        .footer-italic{
          font-family:'Playfair Display',serif;font-style:italic;
          font-size:13px;color:${C.fgMid};transition:color 0.2s;cursor:default;
        }
        .footer-italic:hover{ color:${C.accent}; }

        /* ── RESPONSIVE ── */
        @media(max-width:768px){
          .nav{ padding:18px 24px; }
          .nav-links{ display:none; }
          .hero{ padding:140px 24px 60px; }
          .hero-bottom{ flex-direction:column;align-items:flex-start; }
          .hero-cta{ align-items:flex-start; }
          .section{ padding:60px 24px; }
          /* FIX #9 — disable hover indent on mobile */
          .build-row:hover{ padding-left:0;padding-right:0;margin-left:0;margin-right:0; }
          .build-row{ grid-template-columns:52px 1fr; }
          .status-col{ display:none; }
          .about-grid{ grid-template-columns:1fr; }
          .about-box{ height:340px; }
          .contact-wrap{ padding:60px 24px; }
          .footer-bar{ flex-direction:column;gap:12px;text-align:center; }
        }
      `}</style>

      {/* FIX #10 — Scroll progress bar */}
      <div className="scroll-bar" style={{ width:`${scrollPct}%` }} />

      {/* NAV — FIX #4 nav links now go amber on hover */}
      <nav className="nav">
        <div className="nav-logo">Rayyan Sameer</div>
        <ul className="nav-links">
          <li><a href="#builds">Work</a></li>
          <li><a href="#about">About</a></li>
          <li><a href="#connect">Connect</a></li>
        </ul>
        <a href="https://www.linkedin.com/in/rayyan-s-sameer/" target="_blank" rel="noreferrer" className="nav-cta" aria-label="Open Rayyan's LinkedIn profile">
          Open to work ↗
        </a>
      </nav>

      {/* HERO */}
      <section className="hero">
        <div className="eyebrow">Cloud Engineer &amp; DevOps</div>

        {/* FIX #12 — paren is a personality beat near eyebrow, not above buttons */}
        <p className="paren">( AWS · Kubernetes · Serverless )</p>

        <div style={{ lineHeight:0.88, marginBottom:56 }}>
          <span className="name-solid">Rayyan</span>
          <span className="name-outline">Sameer</span>
          {/* FIX #5 — subtitle at proportional size, more top margin */}
          <span className="name-sub">building cloud infrastructure</span>
        </div>

        {/* FIX #6 — hero-bottom has top border to anchor it */}
        <div className="hero-bottom">
          <p className="hero-desc">
            AWS-native cloud engineer crafting scalable systems, serverless architectures, and Kubernetes-powered infrastructure. Every build is production-grade, documented, and open.
          </p>
          <div className="hero-cta">
            <div style={{ display:"flex", gap:12 }}>
              <a href="#builds" className="btn-main" aria-label="View all builds">View Builds</a>
              <a href="https://github.com/RayyanSameer" target="_blank" rel="noreferrer" className="btn-outline" aria-label="Visit GitHub profile">GitHub ↗</a>
            </div>
          </div>
        </div>
      </section>

      {/* MARQUEE — FIX #18 pauses on hover */}
      <Marquee />

      {/* BUILDS */}
      <div style={{ maxWidth:1400, margin:"0 auto" }}>
        <section className="section" id="builds">
          <Reveal>
            <div className="eyebrow">Selected Builds</div>
            {/* FIX #7 — builds title styling distinct */}
            <h2 className="sec-title">Current<br />Projects</h2>
            {/* FIX #13 — intro sentence with stats */}
            <p className="sec-intro">
              <span>7</span> builds. <span>4</span> live. All open source.
            </p>
          </Reveal>

          <div className="builds-list">
            {builds.map((b, i) => (
              /* FIX #16 — stagger delay increased to 0.08s */
              <Reveal key={b.num} delay={i * 0.08}>
                <div
                  className="build-row"
                  onMouseEnter={() => setHovered(b.num)}
                  onMouseLeave={() => setHovered(null)}
                >
                  <div className="build-num">{b.num}</div>
                  <div>
                    <h3 className="build-title" style={{ color: hovered && hovered !== b.num ? C.fgDim : C.fg }}>
                      {b.title}
                    </h3>
                    <p className="build-desc">{b.desc}</p>
                    <div className="tags-row">
                      {b.tags.map(t => <span key={t} className="tag">{t}</span>)}
                    </div>
                    {/* FIX #14 — build 07 gets a placeholder link */}
                    {b.github
                      ? <a href={b.github} target="_blank" rel="noreferrer" className="build-link" aria-label={`View ${b.title} on GitHub`}>View on GitHub →</a>
                      : <span className="build-soon-link">Coming to Instagram →</span>
                    }
                  </div>
                  <div className="status-col">
                    <span className={`badge ${b.status === "Live" ? "s-live" : b.status === "In Progress" ? "s-prog" : "s-soon"}`}>
                      {b.status === "Live" && "● "}{b.status}
                    </span>
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </section>
      </div>

      {/* ABOUT */}
      <div style={{ background:C.bgAlt, borderTop:`1px solid ${C.border}`, borderBottom:`1px solid ${C.border}` }}>
        <div style={{ maxWidth:1400, margin:"0 auto" }}>
          <section className="section" id="about">
            <Reveal>
              <div className="eyebrow">About</div>
              {/* FIX #7 — about title is italic, visually different from builds */}
              <h2 className="about-section-title">The engineer<br />behind the builds.</h2>
            </Reveal>
            <div className="about-grid">
              <div>
                {/* FIX #15 — more personal, specific quote with left-border treatment */}
                <Reveal>
                  <p className="about-quote">
                    " I build things I'd want to use myself, then write about why they work."
                  </p>
                </Reveal>
                <Reveal delay={0.1}>
                  <p className="about-body">
                    I'm Rayyan , a cloud engineer obsessed with AWS, Kubernetes, and infrastructure that actually scales. I build from scratch, document every decision, and keep everything open source.
                  </p>
                </Reveal>
                <Reveal delay={0.18}>
                  <p className="about-body">
                    From CI/CD pipelines and EKS clusters to serverless architectures and cost tooling , each build solves a real problem. Currently shipping K8s observability and a real-time chat system at scale.
                  </p>
                </Reveal>
                <Reveal delay={0.26}>
                  <div style={{ marginTop:40 }}>
                    <div className="eyebrow" style={{ marginBottom:22 }}>Tech Stack</div>
                    {/* FIX #1 — skills are muted default, amber on hover */}
                    <div className="skills-wrap">
                      {skills.map(s => <div key={s} className="skill">{s}</div>)}
                    </div>
                  </div>
                </Reveal>
              </div>

              {/* FIX #8 — replaced empty box with interactive AWS diagram */}
              <Reveal delay={0.1}>
                <div className="about-box">
                  <div className="about-box-title">AWS Architecture</div>
                  <AboutVisual />
                  <div className="about-box-label">Hover nodes to explore</div>
                </div>
              </Reveal>
            </div>
          </section>
        </div>
      </div>

      {/* CONNECT */}
      {/* FIX #11 — reduced padding on contact section */}
      <div id="connect">
        <div className="contact-wrap">
          <Reveal>
            <div className="eyebrow" style={{ marginBottom:36 }}>Let's Connect</div>
            {/* FIX #7 & #21 — contact title has unique treatment, cleaned up span CSS */}
            <h2 className="contact-big">
              Open to<br />
              <span className="amber">opportunities.</span>
            </h2>
          </Reveal>
          <Reveal delay={0.1}>
            <p style={{ fontSize:16, color:C.fgMid, maxWidth:460, lineHeight:1.8, marginBottom:44, fontWeight:300 }}>
              Whether it's a collaboration, a role, or just a cloud conversation , I'm always up for it.
            </p>
          </Reveal>
          <Reveal delay={0.18}>
            <div className="contact-row">
              <a href="https://www.linkedin.com/in/rayyan-s-sameer/" target="_blank" rel="noreferrer" className="contact-link" aria-label="LinkedIn profile">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect x="2" y="9" width="4" height="12"/><circle cx="4" cy="4" r="2"/></svg>
                LinkedIn
              </a>
              <a href="https://github.com/RayyanSameer" target="_blank" rel="noreferrer" className="contact-link" aria-label="GitHub profile">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"/></svg>
                GitHub
              </a>
              <div className="contact-link" style={{ cursor:"default", opacity:0.36 }} aria-label="Instagram coming soon">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="2" y="2" width="20" height="20" rx="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
                Instagram ( Soon )
              </div>
            </div>
          </Reveal>

          <div className="footer-bar">
            <div className="footer-italic">Rayyan Sameer  Cloud Engineer</div>
            <div>© {new Date().getFullYear()}</div>
            <div style={{ display:"flex", gap:28 }}>
              <a href="https://www.linkedin.com/in/rayyan-s-sameer/" target="_blank" rel="noreferrer">LinkedIn</a>
              <a href="https://github.com/RayyanSameer" target="_blank" rel="noreferrer">GitHub</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
