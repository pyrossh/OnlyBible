<script>
	import PlayStoreIcon from '$lib/icons/playstore.svg?component';
	import AppStoreIcon from '$lib/icons/appstore.svg?component';
	import lightPng from '$lib/images/light.png?enhanced';
	import logoPng from '../../../assets/icon.png';
	import Intro from '$lib/components/intro.svelte';
</script>

<svelte:head>
	<title>Only Bible App</title>
	<meta name="description" content="The only bible app you will ever need" />
</svelte:head>

<main class="flex flex-col mx-4 h-full">
	<!-- ========== HEADER ========== -->
	<header class="text-sm mt-4">
		<nav class="sm:flex sm:flex-1 sm:items-center sm:justify-between" aria-label="Global">
			<div class="flex flex-1">
				<a
					class="flex flex-1 items-center text-xl font-semibold text-gray-200 no-underline focus:outline-none focus:ring-1 focus:ring-gray-600"
					href="/"
					aria-label="Brand"
				>
					<img class="mr-2 w-10 m-0 rounded-xl" src={logoPng} alt="Only Bible App" />
					<div class="flex flex-1">Only Bible App</div>
				</a>
				<div class="sm:hidden">
					<button
						type="button"
						class="hs-collapse-toggle p-2 inline-flex justify-center items-center rounded-lg border border-gray-200 hover:border-gray-100 font-medium text-gray-200 hover:text-white shadow-sm"
						data-hs-collapse="#navbar-collapse-with-animation"
						aria-controls="navbar-collapse-with-animation"
						aria-label="Toggle navigation"
					>
						<svg
							class="hs-collapse-open:hidden flex-shrink-0 size-6"
							xmlns="http://www.w3.org/2000/svg"
							width="24"
							height="24"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
						>
							<line x1="3" x2="21" y1="6" y2="6" />
							<line x1="3" x2="21" y1="12" y2="12" />
							<line x1="3" x2="21" y1="18" y2="18" />
						</svg>
						<svg
							class="hs-collapse-open:block hidden flex-shrink-0 size-6"
							xmlns="http://www.w3.org/2000/svg"
							width="24"
							height="24"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
						>
							<path d="M18 6 6 18" />
							<path d="m6 6 12 12" />
						</svg>
					</button>
				</div>
			</div>
			<div
				id="navbar-collapse-with-animation"
				class="hs-collapse hidden overflow-hidden transition-all duration-300 basis-full grow sm:flex sm:basis-0 sm:justify-end"
			>
				<div class="flex flex-col gap-5 mt-5 sm:flex-row sm:items-center sm:justify-end sm:mt-0">
					<a
						class="font-medium focus:outline-none focus:ring-1 no-underline hover:text-neutral-100 focus:ring-neutral-200"
						href="/about-us"
					>
						About us
					</a>
					<a
						class="font-medium focus:outline-none focus:ring-1 no-underline hover:text-neutral-100 focus:ring-neutral-200"
						href="/privacy-policy"
					>
						Privacy Policy
					</a>
					<a
						class="font-medium focus:outline-none focus:ring-1 no-underline hover:text-neutral-100 focus:ring-neutral-200"
						href="/terms-and-conditions"
					>
						Terms & Conditions
					</a>
				</div>
			</div>
		</nav>
	</header>
	<!-- ========== END HEADER ========== -->

	<!-- ========== HERO ========== -->
	<div class="flex flex-1 flex-col-reverse sm:flex-row items-center mt-10 sm:mt-0">
		<div class="flex flex-col items-center sm:items-start">
			<div class="hidden sm:block sm:mb-4">
				<Intro />
			</div>
			<!-- Buttons -->
			<div class="flex flex-col items-center sm:items-start">
				<h3 class="m-0 my-4">Download it now</h3>
				<div class="flex flex-col sm:flex-row">
					<a
						class="mt-4 sm:mt-0 sm:mr-2"
						href="https://play.google.com/store/apps/details?id=sh.pyros.only_bible_app"
						rel="noopener noreferrer"
						target="blank"
					>
						<PlayStoreIcon class="w-48 sm:w-44" />
					</a>
					<a
						class="mt-8 sm:mt-0"
						href="https://apps.apple.com/us/app/only-bible-app/id6467606465?itsct=apps_box_badge&amp;itscg=30200"
						rel="noopener noreferrer"
						target="blank"
					>
						<AppStoreIcon class="w-48 sm:w-44" />
					</a>
				</div>
			</div>
			<!-- End Buttons -->
		</div>
		<!-- End Col -->
		<!-- Slider -->
		<!-- End Slider -->
		<div
			class="not-prose flex items-center mt-10 sm:mt-20 sm:flex-row [&>picture]:flex [&>picture]:justify-center sm:[&>picture]:justify-end"
		>
			<enhanced:img class="w-9/12" src={lightPng} alt="app screenshot" />
		</div>
		<div class="sm:hidden">
			<Intro />
		</div>
		<!-- End Col -->
	</div>
	<!-- ========== END HERO ========== -->

	<!-- ========== FOOTER ========== -->
	<footer class="text-center py-5 mt-20">
		<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
			<p class="text-sm text-gray-300 dark:text-neutral-400">
				Copyright © 2024 <a
					class="decoration-2 underline underline-offset-2 font-medium hover:text-gray-400 hover:decoration-gray-400"
					href="https://github.com/pyrossh"
				>
					pyrossh
				</a>
			</p>
		</div>
	</footer>
	<!-- ========== END FOOTER ========== -->
</main>
