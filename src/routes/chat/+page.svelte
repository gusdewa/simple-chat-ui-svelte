<script>
	// @ts-nocheck

	import { v4 as uuidv4 } from 'uuid';
	import { formatMessage } from '../../helpers/text-helpers';

	let messages = [];
	let newMessage = '';
	const API_URL = 'http://localhost:8080'; // Replace with your actual API URL
	let conversationId = uuidv4(); // Generate a UUID for the session. You'll need to import or define a uuidv4 function

	async function sendMessage() {
		if (newMessage.trim() === '') return;

		try {
			const response = await fetch(`${API_URL}/chat`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
					Accept: 'text/plain' // Change here to accept plain text
				},
				body: JSON.stringify({
					collection_name: 'external',
					conversation_id: conversationId,
					query: newMessage
				})
			});

			if (!response.ok) {
				throw new Error(`HTTP error! Status: ${response.status}`);
			}

			const data = await response.text(); // Get the response as text
			messages = [...messages, { text: newMessage, sender: 'user' }, { text: data, sender: 'bot' }];
			newMessage = ''; // Clear the input field
		} catch (error) {
			console.error('Fetch error:', error);
			// Optionally, handle the error in your UI
		}
	}

	function handleInput(e) {
		newMessage = e.target.value;
	}

	function handleKeydown(e) {
		if (e.key === 'Enter') {
			e.preventDefault();
			sendMessage();
		}
	}
</script>

<div class="chat-container">
	<div class="chat-history">
		{#each messages as message}
			<div class={`message ${message.sender || 'unknown'}`}>
        {@html formatMessage(message.text)}
			</div>
		{/each}
	</div>
	<div class="message-input">
		<textarea
			bind:value={newMessage}
			on:input={handleInput}
			on:keydown={handleKeydown}
			placeholder="Type a message..."
		/>
		<button on:click={sendMessage}>Send</button>
	</div>
</div>

<style>
	.chat-container {
		display: flex;
		flex-direction: column;
		height: 80vh;
		max-width: var(--column-width);
		margin: 0 auto;
	}
	.chat-history {
		flex: 1;
		overflow-y: auto;
		padding: 1rem;
		background-color: white;
		border-radius: 8px;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
	.message {
		margin-bottom: 0.5rem;
		padding: 0.5rem;
		border-radius: 4px;
		background-color: var(--color-theme-2);
		color: white;
	}
	.message.user {
		background-color: var(--color-theme-1);
	}
	.message-input {
		display: flex;
		padding-top: 1rem;
	}
	textarea {
		flex-grow: 1;
		margin-right: 0.5rem;
		padding: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 4px;
	}
	button {
		background-color: var(--color-theme-1);
		color: white;
		border: none;
		padding: 0.5rem 1rem;
		border-radius: 4px;
		cursor: pointer;
	}
	button:hover {
		background-color: darken(var(--color-theme-1), 10%);
	}
</style>
