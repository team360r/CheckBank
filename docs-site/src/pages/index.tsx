import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import styles from './index.module.css';

const chapters = [
  { num: 0, title: 'The Audit Begins', branch: 'chapter-0-audit-begins', desc: 'Tour the app, discover it\'s broken, set up test infrastructure', time: '~15 min' },
  { num: 1, title: 'Labels Under the Microscope', branch: 'chapter-1-labels', desc: 'Test and fix missing semantic labels on Login and Dashboard', time: '~25 min' },
  { num: 2, title: 'Roles, States, and Actions', branch: 'chapter-2-roles-states', desc: 'Test button roles, toggle states, and custom semantics actions', time: '~30 min' },
  { num: 3, title: 'Contrast on Trial', branch: 'chapter-3-contrast', desc: 'Build a WCAG contrast checker and test every theme colour', time: '~25 min' },
  { num: 4, title: 'Touch Targets and Text Scaling', branch: 'chapter-4-sizing', desc: 'Test minimum touch targets and layout at 200% text scale', time: '~25 min' },
  { num: 5, title: 'Focus Traversal', branch: 'chapter-5-focus', desc: 'Test keyboard tab order and focus management on forms', time: '~25 min' },
  { num: 6, title: 'Live Regions and Announcements', branch: 'chapter-6-announcements', desc: 'Test dynamic content announcements for screen readers', time: '~30 min' },
  { num: 7, title: 'Integration Tests — The Full Journey', branch: 'chapter-7-integration', desc: 'Write cross-screen accessibility tests and a reusable audit helper', time: '~30 min' },
  { num: 8, title: 'Test-Driven Accessibility', branch: 'chapter-8-tda', desc: 'Write tests before code — red, green, refactor for accessibility', time: '~25 min' },
  { num: 9, title: 'Linting and Static Analysis', branch: 'chapter-9-linting', desc: 'Configure lint rules and custom_lint for accessibility', time: '~20 min' },
  { num: 10, title: 'The CI Pipeline — Ship With Confidence', branch: 'chapter-10-ci-pipeline', desc: 'Build a GitHub Actions pipeline with an automated audit report', time: '~25 min' },
];

const features = [
  { icon: '{}', title: 'Test Real Failures',
    desc: 'Write tests that catch accessibility bugs before your users do. Every chapter starts with a failing test.' },
  { icon: '11', title: '11 Progressive Chapters',
    desc: 'From basic semantics to a full CI audit pipeline. ~4.5 hours of hands-on learning.' },
  { icon: '<>', title: 'Red \u2192 Green Flow',
    desc: 'Every chapter: write a failing test, discover the bug, fix the code. Test-Driven Accessibility.' },
];

function HeroSection(): ReactNode {
  return (
    <header className={styles.hero}>
      <div className={styles.heroInner}>
        <p className={styles.heroPre}>Flutter Accessibility Tutorial</p>
        <h1 className={styles.heroTitle}>CheckBank</h1>
        <p className={styles.heroTagline}>
          Your eyes lied to you. Your tests are the truth.<br />
          Test-driven accessibility for Flutter. Every chapter starts with a failing test.
        </p>
        <div className={styles.heroButtons}>
          <Link className={styles.btnPrimary} to="/chapters/audit-begins">Start Chapter 0</Link>
          <Link className={styles.btnSecondary} to="/intro">Read Introduction</Link>
        </div>
      </div>
    </header>
  );
}

function FeaturesSection(): ReactNode {
  return (
    <section className={styles.features}>
      <div className={styles.container}>
        <div className={styles.featureGrid}>
          {features.map((f) => (
            <div key={f.title} className={styles.featureCard}>
              <div className={styles.featureIcon}>{f.icon}</div>
              <h3 className={styles.featureTitle}>{f.title}</h3>
              <p className={styles.featureDesc}>{f.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function ChapterRoadmap(): ReactNode {
  return (
    <section className={styles.roadmap}>
      <div className={styles.container}>
        <h2 className={styles.sectionTitle}>Chapter Roadmap</h2>
        <p className={styles.sectionSubtitle}>Eleven focused chapters, each testing and fixing a different accessibility surface. Total time: roughly 4.5 hours.</p>
        <ol className={styles.chapterList}>
          {chapters.map((ch) => (
            <li key={ch.num} className={styles.chapterItem}>
              <span className={styles.chapterNum}>{ch.num}</span>
              <div className={styles.chapterBody}>
                <div className={styles.chapterHeader}>
                  <strong className={styles.chapterTitle}>{ch.title}</strong>
                  <span className={styles.chapterTime}>{ch.time}</span>
                </div>
                <p className={styles.chapterDesc}>{ch.desc}</p>
              </div>
            </li>
          ))}
        </ol>
      </div>
    </section>
  );
}

function QuickStartSection(): ReactNode {
  return (
    <section className={styles.quickstart}>
      <div className={styles.container}>
        <h2 className={styles.sectionTitle}>Quick Start</h2>
        <p className={styles.sectionSubtitle}>Three steps and you are up — broken app on device, guide in your browser.</p>
        <div className={styles.quickstartGrid}>
          <div className={styles.codeBlock}>
            <p className={styles.codeLabel}>1. Clone and install</p>
            <pre className={styles.pre}><code>{`git clone git@github.com:team360r/checkbank.git
cd checkbank
flutter pub get`}</code></pre>
          </div>
          <div className={styles.codeBlock}>
            <p className={styles.codeLabel}>2. Start the docs site</p>
            <pre className={styles.pre}><code>{`cd docs-site
npm install && npm start
# Opens tutorial at localhost:3000`}</code></pre>
          </div>
          <div className={styles.codeBlock}>
            <p className={styles.codeLabel}>3. Run the app</p>
            <pre className={styles.pre}><code>{`flutter run
# Launch on your device or emulator`}</code></pre>
          </div>
        </div>
      </div>
    </section>
  );
}

function CtaSection(): ReactNode {
  return (
    <section className={styles.cta}>
      <div className={styles.container}>
        <h2 className={styles.ctaTitle}>Ready to expose the truth?</h2>
        <p className={styles.ctaSubtitle}>
          Start with Chapter 0 — tour the app, discover it is broken,
          and write your first failing accessibility test.
        </p>
        <Link className={styles.btnPrimary} to="/chapters/audit-begins">Start Chapter 0: The Audit Begins</Link>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout title={siteConfig.title}
      description="Test-driven accessibility for Flutter. 11 progressive chapters from basic semantics to a full CI audit pipeline.">
      <HeroSection />
      <main>
        <FeaturesSection />
        <ChapterRoadmap />
        <QuickStartSection />
        <CtaSection />
      </main>
    </Layout>
  );
}
