<script>
	import { base } from '$app/paths';
	import { page } from '$app/stores';
</script>

<svelte:head>
	<title>{$page.error?.message} | Only Bible App</title>
</svelte:head>

<main id="content" class="prose">
	<div class="max-w-[50rem] mx-auto px-4 sm:px-6 lg:px-8">
		<div class="flex flex-col">
			<h1 class="text-4xl font-bold">{$page.status} - {$page.error?.message}</h1>
			<p class="my-4">
				{#if $page.status === 404}
					The page you were looking for doesn't exist.
				{:else}
					Something went wrong. Please try again later.
				{/if}
			</p>
			<a href="{base}/" class="underline mt-4"> Go back home </a>
		</div>
	</div>
</main>
