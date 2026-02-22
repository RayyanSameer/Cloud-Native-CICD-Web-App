import React, { useState, useEffect, useRef } from "react";

// --- Custom Hooks ---
const useInView = (options = { threshold: 0.1 }) => {
  const ref = useRef(null);
  const [isIntersecting, setIntersecting] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) setIntersecting(true);
    }, options);

    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, [options]);

  return [ref, isIntersecting];
};

const useScrollProgress = () => {
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      const totalHeight = document.documentElement.scrollHeight - window.innerHeight;
      setProgress((window.scrollY / totalHeight) * 100);
    };
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return progress;
};

// --- Sub-components ---
const Reveal = ({ children, delay = 0, className = "" }) => {
  const [ref, inView] = useInView();
  return (
    <div
      ref={ref}
      className={className}
      style={{
        opacity: inView ? 1 : 0,
        transform: inView ? "none" : "translateY(20px)",
        transition: `all 0.8s cubic-bezier(0.16, 1, 0.3, 1) ${delay}s`,
      }}
    >
      {children}
    </div>
  );
};

const ArchitectureVisual = () => {
  const [active, setActive] = useState(null);
  
  const nodes = [
    { id: "user", label: "User", x: 50, y: 10, icon: "👤" },
    { id: "cdn", label: "CloudFront", x: 50, y: 28, icon: "⚡" },
    { id: "alb", label: "ALB", x: 50, y: 46, icon: "⇄" },
    { id: "eks", label: "EKS", x: 25, y: 64, icon: "☸" },
    { id: "lambda", label: "Lambda", x: 50, y: 64, icon: "λ" },
    { id: "rds", label: "RDS", x: 75, y: 64, icon: "🛢" },
  ];

  const connections = [
    ["user", "cdn"], ["cdn", "alb"], ["alb", "eks"], ["alb", "lambda"], ["alb", "rds"]
  ];

  return (
    <div className="arch-viz">
      <svg className="arch-lines">
        {connections.map(([from, to], i) => {
          const n1 = nodes.find(n => n.id === from);
          const n2 = nodes.find(n => n.id === to);
          const isActive = active === from || active === to;
          return (
            <line
              key={i}
              x1={`${n1.x}%`} y1={`${n1.y}%`}
              x2={`${n2.x}%`} y2={`${n2.y}%`}
              stroke={isActive ? "var(--accent)" : "var(--border)"}
              strokeDasharray={isActive ? "none" : "4 4"}
            />
          );
        })}
      </svg>
      {nodes.map(n => (
        <div
          key={n.id}
          className={`arch-node ${active === n.id ? 'active' : ''}`}
          style={{ left: `${n.x}%`, top: `${n.y}%` }}
          onMouseEnter={() => setActive(n.id)}
          onMouseLeave={() => setActive(null)}
        >
          <div className="node-icon">{n.icon}</div>
          <span>{n.label}</span>
        </div>
      ))}
    </div>
  );
};

// --- Main Component ---
export default function Portfolio() {
  const scrollProgress = useScrollProgress();
  const [hoveredProject, setHoveredProject] = useState(null);

  const projects = [
    { id: "01", title: "AWS Native CI/CD Pipeline", status: "Live", tags: ["CodePipeline", "S3", "IAM"], desc: "Production-ready automated deployment pipeline using AWS developer tools. Zero manual touchpoints from source to prod.", link: "https://github.com/RayyanSameer" },
    { id: "02", title: "AWS EKS 3-Tier App", status: "Live", tags: ["Kubernetes", "RDS", "ALB"], desc: "Scalable three-tier architecture on EKS with managed node groups and automated load balancing.", link: "https://github.com/RayyanSameer" },
    { id: "03", title: "Serverless Data Retrieval", status: "Live", tags: ["Lambda", "DynamoDB", "API Gateway"], desc: "Event-driven data pipeline optimized for performance and cost. Built for massive throughput.", link: "https://github.com/RayyanSameer" },
    { id: "04", title: "Kubernetes Observation Tool", status: "In Progress", tags: ["Prometheus", "Grafana", "Helm"], desc: "Unified metrics and logging for K8s clusters. Giving developers a single pane of glass into cluster health.", link: "https://github.com/RayyanSameer" },
    { id: "05", title: "Cloud Content & Insights", status: "Coming Soon", tags: ["Technical Writing", "Architecture"], desc: "Deep dives into cloud patterns, visual architecture breakdowns, and DevOps best practices.", link: null }
  ];

  return (
    <div className="portfolio-root">
      <style>{`
        :root {
          --bg: #0e0f0d;
          --bg-alt: #121310;
          --surface: #191b17;
          --border: #252721;
          --fg: #edecea;
          --fg-mid: #888882;
          --fg-dim: #484942;
          --accent: #E8B86D;
          --accent-bg: #1e1608;
          --live: #7dc98a;
          --prog: #c4924a;
        }

        @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500&family=Playfair+Display:ital,wght@0,700;0,900;1,400&display=swap');

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: var(--bg); color: var(--fg); font-family: 'DM Sans', sans-serif; -webkit-font-smoothing: antialiased; }
        
        .progress-bar { position: fixed; top: 0; left: 0; height: 2px; background: var(--accent); z-index: 1000; transition: width 0.1s ease; }
        
        nav { position: fixed; top: 0; width: 100%; display: flex; justify-content: space-between; align-items: center; padding: 24px 50px; background: rgba(14,15,13,0.8); backdrop-filter: blur(12px); border-bottom: 1px solid var(--border); z-index: 100; }
        .logo { font-family: 'Playfair Display', serif; font-style: italic; font-weight: 700; font-size: 1.1rem; }
        .nav-links { display: flex; gap: 30px; }
        .nav-links a { text-decoration: none; color: var(--fg-mid); font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; transition: color 0.3s; }
        .nav-links a:hover { color: var(--accent); }

        .hero { padding: 180px 50px 100px; max-width: 1400px; margin: 0 auto; }
        .eyebrow { font-size: 12px; text-transform: uppercase; letter-spacing: 4px; color: var(--fg-dim); margin-bottom: 30px; display: flex; align-items: center; gap: 15px; }
        .eyebrow::before { content: ""; width: 30px; height: 1px; background: var(--fg-dim); }
        
        h1 { font-family: 'Playfair Display', serif; font-size: clamp(60px, 10vw, 140px); line-height: 0.9; margin-bottom: 40px; }
        .outline { color: transparent; -webkit-text-stroke: 1px var(--accent); }
        .hero-sub { font-family: 'Playfair Display', serif; font-style: italic; font-weight: 400; font-size: clamp(24px, 4vw, 50px); color: var(--fg-mid); display: block; margin-top: 10px; }

        .project-row { display: grid; grid-template-columns: 80px 1fr 150px; padding: 40px 0; border-bottom: 1px solid var(--border); transition: all 0.4s; cursor: default; }
        .project-row:hover { background: var(--surface); padding-left: 20px; padding-right: 20px; }
        .project-id { font-family: 'Playfair Display', serif; font-style: italic; color: var(--fg-dim); }
        .project-title { font-family: 'Playfair Display', serif; font-size: clamp(24px, 3vw, 40px); margin-bottom: 10px; transition: color 0.3s; }
        .project-desc { color: var(--fg-mid); max-width: 600px; line-height: 1.6; margin-bottom: 20px; font-size: 15px; }
        
        .tag-list { display: flex; gap: 8px; flex-wrap: wrap; }
        .tag { font-size: 10px; border: 1px solid var(--border); padding: 4px 10px; text-transform: uppercase; color: var(--fg-dim); transition: 0.3s; }
        .project-row:hover .tag { border-color: var(--accent); color: var(--accent); }

        .arch-viz { position: relative; width: 100%; height: 500px; background: var(--bg-alt); border: 1px solid var(--border); overflow: hidden; margin-top: 50px; }
        .arch-lines { position: absolute; width: 100%; height: 100%; pointer-events: none; }
        .arch-node { position: absolute; transform: translate(-50%, -50%); text-align: center; cursor: pointer; transition: 0.3s; }
        .node-icon { width: 50px; height: 50px; background: var(--bg); border: 1px solid var(--border); display: grid; place-items: center; font-size: 20px; margin-bottom: 8px; transition: 0.3s; }
        .arch-node span { font-size: 10px; text-transform: uppercase; letter-spacing: 1px; color: var(--fg-dim); }
        .arch-node.active .node-icon { border-color: var(--accent); background: var(--accent-bg); box-shadow: 0 0 20px rgba(232, 184, 109, 0.2); }
        .arch-node.active span { color: var(--accent); }

        footer { padding: 100px 50px 40px; border-top: 1px solid var(--border); margin-top: 100px; }
        .contact-big { font-family: 'Playfair Display', serif; font-size: clamp(40px, 8vw, 100px); margin-bottom: 60px; }

        @media (max-width: 768px) {
          nav { padding: 20px; }
          .nav-links { display: none; }
          .hero { padding-left: 20px; padding-right: 20px; }
          .project-row { grid-template-columns: 1fr; gap: 10px; }
          .status-cell { display: none; }
        }
      `}</style>

      <div className="progress-bar" style={{ width: `${scrollProgress}%` }} />

      <nav>
        <div className="logo">Rayyan Sameer</div>
        <div className="nav-links">
          <a href="#work">Work</a>
          <a href="#about">About</a>
          <a href="#contact">Contact</a>
        </div>
        <a href="https://linkedin.com/in/rayyan-s-sameer" className="logo" style={{fontSize: '11px', textDecoration: 'none', color: 'var(--accent)'}}>AVAILABLE FOR ROLES ↗</a>
      </nav>

      <section className="hero">
        <Reveal>
          <div className="eyebrow">Cloud Systems & Infrastructure</div>
          <h1>
            Building <span className="outline">Elastic</span>
            <span className="hero-sub">Production-grade cloud environments</span>
          </h1>
          <p style={{ maxWidth: '500px', color: 'var(--fg-mid)', lineHeight: 1.8 }}>
            Specializing in AWS architecture, Kubernetes orchestration, and 
            streamlining CI/CD workflows. I focus on making infrastructure 
            invisible, scalable, and cost-efficient.
          </p>
        </Reveal>
      </section>

      <section id="work" style={{ padding: '0 50px' }}>
        <Reveal>
          <div className="eyebrow">Selected Builds</div>
        </Reveal>
        <div className="projects-list">
          {projects.map((p, i) => (
            <Reveal key={p.id} delay={i * 0.1}>
              <div 
                className="project-row"
                onMouseEnter={() => setHoveredProject(p.id)}
                onMouseLeave={() => setHoveredProject(null)}
              >
                <div className="project-id">{p.id}</div>
                <div>
                  <h3 className="project-title" style={{ color: hoveredProject && hoveredProject !== p.id ? 'var(--fg-dim)' : 'var(--fg)' }}>
                    {p.title}
                  </h3>
                  <p className="project-desc">{p.desc}</p>
                  <div className="tag-list">
                    {p.tags.map(t => <span key={t} className="tag">{t}</span>)}
                  </div>
                  {p.link && <a href={p.link} style={{ display: 'block', marginTop: '20px', color: 'var(--accent)', fontSize: '12px', textDecoration: 'none' }}>GITHUB ↗</a>}
                </div>
                <div className="status-cell" style={{ textAlign: 'right', fontSize: '10px', letterSpacing: '1px', color: p.status === 'Live' ? 'var(--live)' : 'var(--prog)' }}>
                  {p.status.toUpperCase()}
                </div>
              </div>
            </Reveal>
          ))}
        </div>
      </section>

      <section id="about" style={{ padding: '100px 50px' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '80px', alignItems: 'center' }}>
          <div>
            <Reveal>
              <div className="eyebrow">The Stack</div>
              <h2 style={{ fontFamily: 'Playfair Display', fontSize: '40px', marginBottom: '30px' }}>Architecture first. <br/>Code second.</h2>
              <p style={{ color: 'var(--fg-mid)', lineHeight: 1.8, marginBottom: '20px' }}>
                I treat infrastructure as a software problem. Every cluster I deploy and every pipeline I build 
                is designed to be ephemeral, reproducible, and documented.
              </p>
              <div className="tag-list" style={{ marginTop: '30px' }}>
                {["Terraform", "Docker", "Python", "Go", "CI/CD", "Linux"].map(s => (
                  <span key={s} className="tag" style={{ padding: '10px 20px', fontSize: '12px' }}>{s}</span>
                ))}
              </div>
            </Reveal>
          </div>
          <Reveal delay={0.2}>
            <ArchitectureVisual />
          </Reveal>
        </div>
      </section>

      <footer id="contact">
        <Reveal>
          <div className="contact-big">
            Let's build <br/>
            <span className="outline">something scalable.</span>
          </div>
          <div style={{ display: 'flex', gap: '40px' }}>
            <a href="https://linkedin.com/in/rayyan-s-sameer" style={{ color: 'var(--fg)', textDecoration: 'none', borderBottom: '1px solid var(--accent)' }}>LinkedIn</a>
            <a href="https://github.com/RayyanSameer" style={{ color: 'var(--fg)', textDecoration: 'none', borderBottom: '1px solid var(--accent)' }}>GitHub</a>
            <span style={{ color: 'var(--fg-dim)' }}>© {new Date().getFullYear()}</span>
          </div>
        </Reveal>
      </footer>
    </div>
  );
}
