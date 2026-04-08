import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'CheckBank Tutorial',
  tagline: 'Your eyes lied to you. Your tests are the truth.',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://checkbank-tutorial.dev',
  baseUrl: '/',

  organizationName: 'team360r',
  projectName: 'CheckBank',

  onBrokenLinks: 'throw',

  themes: ['@docusaurus/theme-mermaid'],
  markdown: {
    mermaid: true,
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'CheckBank Tutorial',
      logo: {
        alt: 'CheckBank Tutorial Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Tutorial',
        },
        {
          to: '/chapters/audit-begins',
          label: 'Get Started',
          position: 'right',
        },
      ],
      style: 'dark',
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Tutorial',
          items: [
            {
              label: 'Introduction',
              to: '/intro',
            },
            {
              label: 'Chapter 0: The Audit Begins',
              to: '/chapters/audit-begins',
            },
          ],
        },
      ],
      copyright: `Copyright \u00a9 ${new Date().getFullYear()} CheckBank Tutorial. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['dart', 'bash', 'yaml', 'json', 'swift', 'kotlin'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
