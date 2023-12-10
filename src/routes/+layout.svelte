<script>
	import Header from './Header.svelte';
	import './styles.css';

	let apiStatusMessage = '';
	let isError = false;

	async function checkApi() {
		try {
			const response = await fetch(`${import.meta.env.VITE_API_URL}/health`);
			if (response.ok) {
				apiStatusMessage = 'API is Ready';
				isError = false;
			} else {
				throw new Error('API check failed');
			}
		} catch (error) {
			apiStatusMessage = `API is NOT Ready. Please check: ${import.meta.env.VITE_API_URL}`;
			isError = true;
		}
	}
</script>

<div class="app">
	<Header />

	<main>
		<slot />
	</main>

	<footer>
		<p>visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to learn SvelteKit</p>
		<button on:click={checkApi}>Check API</button>
		<p class:isError>{apiStatusMessage}</p>
	</footer>
</div>

<style>
	.app {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
	}

	main {
		flex: 1;
		display: flex;
		flex-direction: column;
		padding: 1rem;
		width: 100%;
		max-width: 64rem;
		margin: 0 auto;
		box-sizing: border-box;
	}

	footer {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		padding: 12px;
	}

	footer a {
		font-weight: bold;
	}

	@media (min-width: 480px) {
		footer {
			padding: 12px 0;
		}
	}

	/* Existing styles... */

	.isError {
		color: red;
	}

	button {
		margin-top: 12px;
		padding: 8px 16px;
		/* Add more button styles as needed */
	}
</style>
