// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'next-task',
			tagline: 'Task queue runner for AI coding agents',
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/vonwao/next-task' },
			],
			sidebar: [
				{
					label: 'Getting Started',
					items: [
						{ label: 'Introduction', slug: 'getting-started/introduction' },
						{ label: 'Installation', slug: 'getting-started/installation' },
						{ label: 'Quick Start', slug: 'getting-started/quick-start' },
					],
				},
				{
					label: 'Concepts',
					items: [
						{ label: 'How It Works', slug: 'concepts/how-it-works' },
						{ label: 'Task Files', slug: 'concepts/task-files' },
						{ label: 'Agents', slug: 'concepts/agents' },
						{ label: 'Loop Mode', slug: 'concepts/loop-mode' },
					],
				},
				{
					label: 'Commands',
					autogenerate: { directory: 'commands' },
				},
				{
					label: 'Configuration',
					items: [
						{ label: 'Config File', slug: 'configuration/config-file' },
						{ label: 'AGENT.md', slug: 'configuration/agent-md' },
					],
				},
				{
					label: 'Roadmap',
					items: [
						{ label: 'Ralph Integration', slug: 'roadmap/ralph-integration' },
					],
				},
			],
			customCss: [],
			head: [],
		}),
	],
});
