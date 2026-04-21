<script lang="ts">
	import { base } from '$app/paths';

	const version = '0.2.0';
	const releaseDate = 'April 2026';
</script>

<svelte:head>
	<title>Download - Tiny Home/End</title>
	<meta name="description" content="Download Tiny Home/End for macOS. Free, open source, and ready to use." />
</svelte:head>

<div class="page">
	<header class="header">
		<div class="container">
			<a href="{base}/" class="back-link">← Back to Home</a>
		</div>
	</header>

	<main class="main">
		<div class="container">
			<h1>Download</h1>

			<div class="download-card">
				<div class="download-header">
					<div class="app-icon">⌨️</div>
					<div>
						<h2>Tiny Home/End for macOS</h2>
						<p class="version">Version {version} · {releaseDate}</p>
					</div>
				</div>

				<div class="download-buttons">
					<a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings/releases/latest" 
					   class="button button-primary button-large"
					   target="_blank"
					   rel="noopener">
						⬇️ Download from GitHub Releases
					</a>
					
					<p class="download-note">
						<strong>Coming soon:</strong> Signed DMG with one-click installation. 
						Check <a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings/releases" target="_blank" rel="noopener">GitHub Releases</a> for the latest version.
					</p>
				</div>
			</div>

			<div class="install-section">
				<h2>Installation</h2>
				
				<div class="steps">
					<div class="step">
						<div class="step-number">1</div>
						<div class="step-content">
							<h3>Download the DMG</h3>
							<p>Click the download button above to get the latest version from GitHub Releases.</p>
						</div>
					</div>

					<div class="step">
						<div class="step-number">2</div>
						<div class="step-content">
							<h3>Open the DMG</h3>
							<p>Double-click the downloaded file to mount the disk image.</p>
						</div>
					</div>

					<div class="step">
						<div class="step-number">3</div>
						<div class="step-content">
							<h3>Drag to Applications</h3>
							<p>Drag "Tiny Home End.app" to your Applications folder.</p>
						</div>
					</div>

					<div class="step">
						<div class="step-number">4</div>
						<div class="step-content">
							<h3>Launch the App</h3>
							<p>Open from Applications. The keyboard icon will appear in your menu bar.</p>
						</div>
					</div>

					<div class="step">
						<div class="step-number">5</div>
						<div class="step-content">
							<h3>Enable Bindings</h3>
							<p>Click the menu bar icon and enable Windows-like bindings. Your existing keybindings will be backed up automatically.</p>
						</div>
					</div>
				</div>
			</div>

			<div class="alternative-section">
				<h2>Alternative Installation</h2>
				
				<div class="alt-method">
					<h3>🍺 Homebrew (Coming Soon)</h3>
					<p>Once the Homebrew cask is approved, you'll be able to install with:</p>
					<pre><code>brew install --cask tiny-home-end</code></pre>
				</div>

				<div class="alt-method">
					<h3>💻 Build from Source</h3>
					<p>Want to build it yourself? Clone the repository and build:</p>
					<pre><code>git clone https://github.com/adenearnshaw/tiny-mac-home-end-bindings.git
cd tiny-mac-home-end-bindings
./build-app.sh</code></pre>
					<p class="note">The app will be in <code>build/Tiny Home End.app</code></p>
				</div>
			</div>

			<div class="requirements-section">
				<h2>System Requirements</h2>
				<ul>
					<li><strong>macOS Sonoma (14.0) or later</strong></li>
					<li>Apple Silicon or Intel processor</li>
					<li>~2MB disk space</li>
				</ul>
			</div>

			<div class="help-section">
				<h2>Need Help?</h2>
				<p>
					If you encounter any issues, check the 
					<a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings#readme" target="_blank" rel="noopener">README</a> 
					or <a href="https://github.com/adenearnshaw/tiny-mac-home-end-bindings/issues" target="_blank" rel="noopener">open an issue</a> 
					on GitHub.
				</p>
			</div>
		</div>
	</main>

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
		max-width: 900px;
		margin: 0 auto;
		padding: 0 24px;
	}

	.header {
		padding: 24px 0;
		border-bottom: 1px solid #e5e5e5;
	}

	.back-link {
		color: #007aff;
		text-decoration: none;
		font-weight: 500;
	}

	.back-link:hover {
		text-decoration: underline;
	}

	.main {
		flex: 1;
		padding: 60px 0;
	}

	h1 {
		font-size: 48px;
		font-weight: 700;
		margin: 0 0 40px 0;
		letter-spacing: -0.02em;
	}

	h2 {
		font-size: 32px;
		font-weight: 700;
		margin: 48px 0 24px 0;
		letter-spacing: -0.01em;
	}

	.download-card {
		background: linear-gradient(135deg, #007aff 0%, #5856d6 100%);
		color: white;
		border-radius: 16px;
		padding: 40px;
		margin-bottom: 60px;
	}

	.download-header {
		display: flex;
		align-items: center;
		gap: 24px;
		margin-bottom: 32px;
	}

	.app-icon {
		font-size: 64px;
	}

	.download-header h2 {
		margin: 0;
		color: white;
	}

	.version {
		margin: 4px 0 0 0;
		opacity: 0.9;
	}

	.download-buttons {
		text-align: center;
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

	.button-large {
		padding: 18px 40px;
		font-size: 18px;
	}

	.download-note {
		margin-top: 16px;
		opacity: 0.9;
		font-size: 14px;
	}

	.download-note a {
		color: white;
		text-decoration: underline;
	}

	.steps {
		display: flex;
		flex-direction: column;
		gap: 24px;
	}

	.step {
		display: flex;
		gap: 20px;
		align-items: flex-start;
	}

	.step-number {
		flex-shrink: 0;
		width: 40px;
		height: 40px;
		background: #007aff;
		color: white;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		font-weight: 700;
		font-size: 18px;
	}

	.step-content h3 {
		margin: 0 0 8px 0;
		font-size: 18px;
		font-weight: 600;
	}

	.step-content p {
		margin: 0;
		color: #666;
	}

	.alternative-section,
	.requirements-section,
	.help-section {
		margin-top: 60px;
	}

	.alt-method {
		background: #f8f9fa;
		padding: 24px;
		border-radius: 12px;
		margin-bottom: 20px;
	}

	.alt-method h3 {
		margin: 0 0 12px 0;
		font-size: 20px;
		font-weight: 600;
	}

	.alt-method p {
		margin: 0 0 12px 0;
		color: #666;
	}

	pre {
		background: #1a1a1a;
		color: #0f0;
		padding: 16px;
		border-radius: 8px;
		overflow-x: auto;
		margin: 12px 0;
	}

	code {
		font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
		font-size: 14px;
	}

	.note {
		font-size: 14px;
		color: #666;
	}

	.requirements-section ul {
		list-style: none;
		padding: 0;
	}

	.requirements-section li {
		padding: 12px 0;
		border-bottom: 1px solid #e5e5e5;
	}

	.requirements-section li:last-child {
		border-bottom: none;
	}

	.help-section {
		background: #f8f9fa;
		padding: 32px;
		border-radius: 12px;
		text-align: center;
	}

	.help-section a {
		color: #007aff;
		font-weight: 600;
		text-decoration: none;
	}

	.help-section a:hover {
		text-decoration: underline;
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
			font-size: 36px;
		}

		h2 {
			font-size: 28px;
		}

		.download-card {
			padding: 24px;
		}

		.download-header {
			flex-direction: column;
			text-align: center;
		}

		.app-icon {
			font-size: 48px;
		}
	}
</style>
