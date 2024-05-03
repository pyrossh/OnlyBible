<script>
	import { afterNavigate } from '$app/navigation';
	import '../app.css';

	afterNavigate(() => {
		window.HSStaticMethods.autoInit();
	});
</script>

<div class="prose mx-auto">
	<slot />
</div>

<style lang="postcss">
	:global(html) {
		background-color: #482929;
	}
</style>
