<script>
	import 'virtual:uno.css';
	import '@unocss/reset/tailwind.css';
</script>

<svelte:head>
	<title>Only Bible App</title>
	<meta name="description" content="The only bible app you will ever need" />
</svelte:head>

<!-- ========== HEADER ========== -->
<header class="mb-auto flex flex-wrap sm:justify-start sm:flex-nowrap w-full text-sm py-4">
	<nav
		class="w-full px-4 sm:flex sm:items-center sm:justify-between sm:px-6 lg:px-8"
		aria-label="Global"
	>
		<div class="flex items-center justify-between">
			<a
				class="flex items-center text-xl font-semibold text-gray-800 focus:outline-none focus:ring-1 focus:ring-gray-600"
				href="/"
				aria-label="Brand"
			>
				<img
					class="mr-2 w-1/8 rounded-3"
					src="https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/59/26/b8/5926b8c7-b993-c4d4-8945-1fe3de765e27/AppIcon-0-0-1x_U007emarketing-0-7-0-0-85-220.png/540x540bb.jpg"
					alt="Only Bible App"
				/>
				Only Bible App
			</a>
			<div class="sm:hidden">
				<button
					type="button"
					class="hs-collapse-toggle p-2 inline-flex justify-center items-center gap-2 rounded-lg border border-gray-700 hover:border-gray-600 font-medium text-gray-300 hover:text-white shadow-sm align-middle focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-900 focus:ring-blue-600 transition-all text-sm dark:border-neutral-700 dark:hover:border-neutral-600"
					data-hs-collapse="#navbar-collapse-with-animation"
					aria-controls="navbar-collapse-with-animation"
					aria-label="Toggle navigation"
				>
					<svg
						class="hs-collapse-open:hidden flex-shrink-0 size-4"
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
						class="hs-collapse-open:block hidden flex-shrink-0 size-4"
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
			class="hs-collapse hidden overflow-hidden transition-all duration-300 basis-full grow sm:block"
		>
			<div
				class="flex flex-col gap-5 mt-5 sm:flex-row sm:items-center sm:justify-end sm:mt-0 text-gray-400"
			>
				<a
					class="font-medium hover:text-gray-500 focus:outline-none focus:ring-1 focus:ring-gray-600 dark:text-neutral-400 dark:hover:text-neutral-500 dark:focus:ring-neutral-500"
					href="/about-us"
				>
					About us
				</a>
				<a
					class="font-medium hover:text-gray-500 focus:outline-none focus:ring-1 focus:ring-gray-600 dark:text-neutral-400 dark:hover:text-neutral-500 dark:focus:ring-neutral-500"
					href="/privacy-policy"
				>
					Privacy Policy
				</a>
				<a
					class="font-medium hover:text-gray-500 focus:outline-none focus:ring-1 focus:ring-gray-600 dark:text-neutral-400 dark:hover:text-neutral-500 dark:focus:ring-neutral-500"
					href="/terms-and-conditions"
				>
					Terms & Conditions
				</a>
			</div>
		</div>
	</nav>
</header>
<!-- ========== END HEADER ========== -->

<!-- ========== MAIN CONTENT ========== -->
<main id="content" class="mt-10 sm:mt-20 prose">
	<!-- Hero -->
	<div class="max-w-[50rem] px-4 sm:px-6 lg:px-8">
		<!-- Grid -->
		<div class="flex flex-col sm:flex-row">
			<div class="flex flex-1 flex-col items-center">
				<h1
					class="block text-3xl font-bold text-center sm:text-left text-gray-800 sm:text-4xl lg:leading-tight dark:text-white"
				>
					The only bible app you will ever need
				</h1>
				<p class="mt-3 text-lg text-gray-800 dark:text-neutral-400">
					No ads, No in-app purchases, No distractions.
				</p>

				<!-- Buttons -->
				<div class="flex mt-4">
					<a
						class="flex-1 mr-2 -ml-3"
						href="https://play.google.com/store/apps/details?id=sh.pyros.only_bible_app"
						rel="noopener noreferrer"
						target="blank"
					>
						<img
							class="w-48"
							alt="Get it on Google Play"
							src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
						/>
					</a>
					<a
						class="flex-1 mt-2"
						href="https://apps.apple.com/us/app/only-bible-app/id6467606465?itsct=apps_box_badge&amp;itscg=30200"
						rel="noopener noreferrer"
						target="blank"
					>
						<img
							class="w-32"
							src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1695600000"
							alt="Download on the App Store"
						/>
					</a>
				</div>
				<!-- End Buttons -->
			</div>
			<!-- End Col -->
			<div class="flex flex-1 flex-col mt-10 sm:mt-0 sm:flex-row items-center">
				<img class="w-7/8" src="/images/light.png" alt="app light screen shot" />
				<img class="w-7/8" src="/images/dark.png" alt="app dark screen shot" />
			</div>
			<!-- End Col -->
		</div>
		<!-- End Grid -->
	</div>
	<!-- End Hero -->
</main>
<!-- ========== END MAIN CONTENT ========== -->

<!-- ========== FOOTER ========== -->
<footer class="text-center py-5 mt-20">
	<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
		<p class="text-sm text-gray-800 dark:text-neutral-400">
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
