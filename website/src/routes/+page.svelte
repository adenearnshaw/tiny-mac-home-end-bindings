<script lang="ts">
	import { base } from '$app/paths';
	
	const features = [
		{
			icon: '⌨️',
			title: 'Windows-like Behavior',
			description: 'Home and End keys work like they do on Windows - jump to line start/end, not document'
		},
		{
			icon: '🔒',
			title: 'Safe & Reversible',
			description: 'Automatically backs up your existing keybindings before any changes'
		},
		{
			icon: '⚡',
			title: 'Instant Toggle',
			description: 'Enable or disable with Cmd+Shift+K. Menu bar icon shows current state'
		},
		{
			icon: '🎨',
			title: 'Customizable',
			description: 'Choose line vs paragraph behavior, Ctrl vs Cmd modifiers, and more'
		},
		{
			icon: '🚀',
			title: 'Launch at Login',
			description: 'Start automatically when you log in. Settings persist across restarts'
		},
		{
			icon: '✨',
			title: 'Native macOS',
			description: 'Built with Swift & SwiftUI. No Electron, no bloat. Just 2MB installed'
		}
	];

	const keyBindings = [
		{ key: 'Home', action: 'Beginning of line' },
		{ key: 'End', action: 'End of line' },
		{ key: 'Shift+Home', action: 'Select to line start' },
		{ key: 'Shift+End', action: 'Select to line end' },
		{ key: 'Ctrl+Home', action: 'Beginning of document' },
		{ key: 'Ctrl+End', action: 'End of document' }
	];
</script>

<svelte:head>
	<title>Tiny Home/End - Windows-like Home/End Keys for macOS</title>
	<meta name="description" content="Make Home and End keys on macOS work like Windows. Native menu bar app with automatic backups." />
</svelte:head>

<div class="page">
	<!-- Hero Section -->
	<header class="hero">
		<div class="container">
			<div class="hero-icon">⌨️</div>
			<h1>Tiny Home/End</h1>
			<p class="tagline">Windows-like Home/End key behavior for macOS</p>
			
			<div class="hero-buttons">
				<a href="{base}/download" class="button button-primary">
					Download v0.2.0
				</a>
				<a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings" 
				   class="button button-secondary" 
				   target="_blank" 
				   rel="noopener">
					View on GitHub
				</a>
			</div>

			<p class="compatibility">
				macOS Sonoma (14.0) and later · Free & Open Source (MIT License)
			</p>
		</div>
	</header>

	<!-- Problem/Solution -->
	<section class="section section-alt">
		<div class="container">
			<h2>The Problem</h2>
			<p class="large-text">
				Coming from Windows or Linux? Frustrated that Home/End jump to the start/end of the 
				<strong>entire document</strong> instead of the current <strong>line</strong>?
			</p>
			<p class="large-text">
				You're not alone. This tiny app fixes that.
			</p>
		</div>
	</section>

	<!-- Key Bindings -->
	<section class="section">
		<div class="container">
			<h2>What You Get</h2>
			<div class="keybindings-grid">
				{#each keyBindings as binding}
					<div class="keybinding-card">
						<code class="key">{binding.key}</code>
						<div class="arrow">→</div>
						<div class="action">{binding.action}</div>
					</div>
				{/each}
			</div>
		</div>
	</section>

	<!-- Features -->
	<section class="section section-alt">
		<div class="container">
			<h2>Features</h2>
			<div class="features-grid">
				{#each features as feature}
					<div class="feature-card">
						<div class="feature-icon">{feature.icon}</div>
						<h3>{feature.title}</h3>
						<p>{feature.description}</p>
					</div>
				{/each}
			</div>
		</div>
	</section>

	<!-- CTA -->
	<section class="section cta-section">
		<div class="container">
			<h2>Ready to Get Started?</h2>
			<p class="large-text">
				Download now and make your Mac keyboard feel like home.
			</p>
			<a href="{base}/download" class="button button-primary button-large">
				Download Tiny Home/End
			</a>
		</div>
	</section>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<p>
				Made by <a href="https://github.com/adenearnshaw" target="_blank" rel="noopener">Aden Earnshaw</a>
				· <a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings" target="_blank" rel="noopener">Source Code</a>
				· <a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings/blob/main/LICENSE" target="_blank" rel="noopener">MIT License</a>
			</p>
		</div>
	</footer>
</div>

<style>
	:global(body) {
		margin: 0;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
		background: #fff;
		color: #1a1a1a;
		line-height: 1.6;
	}

	:global(*) {
		box-sizing: border-box;
	}

	.page {
		min-height: 100vh;
		display: flex;
		flex-direction: column;
	}

	.container {
		max-width: 1200px;
		margin: 0 auto;
		padding: 0 24px;
	}

	.section {
		padding: 80px 0;
	}

	.section-alt {
		background: #f8f9fa;
	}

	.hero {
		background: linear-gradient(135deg, #007aff 0%, #5856d6 100%);
		color: white;
		padding: 120px 0;
		text-align: center;
	}

	.hero-icon {
		font-size: 80px;
		margin-bottom: 24px;
	}

	h1 {
		font-size: 56px;
		font-weight: 700;
		margin: 0 0 16px 0;
		letter-spacing: -0.02em;
	}

	.tagline {
		font-size: 24px;
		margin: 0 0 40px 0;
		opacity: 0.95;
	}

	.hero-buttons {
		display: flex;
		gap: 16px;
		justify-content: center;
		flex-wrap: wrap;
		margin-bottom: 32px;
	}

	.button {
		display: inline-block;
		padding: 14px 32px;
		border-radius: 8px;
		font-size: 16px;
		font-weight: 600;
		text-decoration: none;
		transition: all 0.2s;
	}

	.button-primary {
		background: white;
		color: #007aff;
	}

	.button-primary:hover {
		transform: translateY(-2px);
		box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
	}

	.button-secondary {
		background: rgba(255, 255, 255, 0.2);
		color: white;
		border: 2px solid white;
	}

	.button-secondary:hover {
		background: rgba(255, 255, 255, 0.3);
	}

	.button-large {
		padding: 18px 40px;
		font-size: 18px;
	}

	.compatibility {
		margin-top: 24px;
		opacity: 0.8;
		font-size: 14px;
	}

	h2 {
		font-size: 40px;
		font-weight: 700;
		margin: 0 0 48px 0;
		text-align: center;
		letter-spacing: -0.01em;
	}

	.large-text {
		font-size: 20px;
		line-height: 1.7;
		max-width: 800px;
		margin: 0 auto 24px auto;
		text-align: center;
	}

	.keybindings-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
		gap: 16px;
		max-width: 900px;
		margin: 0 auto;
	}

	.keybinding-card {
		background: white;
		border: 2px solid #e5e5e5;
		border-radius: 12px;
		padding: 20px;
		display: flex;
		align-items: center;
		gap: 16px;
		transition: all 0.2s;
	}

	.keybinding-card:hover {
		border-color: #007aff;
		transform: translateY(-2px);
		box-shadow: 0 4px 12px rgba(0, 122, 255, 0.1);
	}

	.key {
		background: #f5f5f7;
		padding: 8px 16px;
		border-radius: 6px;
		font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
		font-size: 14px;
		font-weight: 600;
		color: #1a1a1a;
		white-space: nowrap;
	}

	.arrow {
		color: #999;
		font-size: 20px;
	}

	.action {
		flex: 1;
		font-weight: 500;
		color: #555;
	}

	.features-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
		gap: 32px;
	}

	.feature-card {
		text-align: center;
	}

	.feature-icon {
		font-size: 48px;
		margin-bottom: 16px;
	}

	h3 {
		font-size: 20px;
		font-weight: 600;
		margin: 0 0 12px 0;
	}

	.feature-card p {
		color: #666;
		margin: 0;
	}

	.cta-section {
		text-align: center;
		padding: 100px 0;
	}

	.footer {
		background: #1a1a1a;
		color: white;
		padding: 40px 0;
		margin-top: auto;
		text-align: center;
	}

	.footer a {
		color: #007aff;
		text-decoration: none;
	}

	.footer a:hover {
		text-decoration: underline;
	}

	@media (max-width: 768px) {
		h1 {
			font-size: 40px;
		}

		.tagline {
			font-size: 18px;
		}

		h2 {
			font-size: 32px;
		}

		.large-text {
			font-size: 18px;
		}

		.section {
			padding: 60px 0;
		}

		.hero {
			padding: 80px 0;
		}

		.hero-icon {
			font-size: 60px;
		}
	}
</style>
