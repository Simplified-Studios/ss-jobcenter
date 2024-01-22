let currentJob = 0;
let currentLicense = 0;

window.addEventListener('message', function(event) {
    if (event.data.type == "open") {
        $('html, body').css('display', 'flex');
        config = event.data.config;
        Object.entries(config.Jobs).forEach(([jobKey, job]) => {
            var dynamicContent = `
            <div class="mx-auto max-w-md overflow-hidden rounded-lg h-[51rem] bg-slate-900 mb-10" style="display: none" id="job-${jobKey}">
                <img src="./img/${job.image}" class="aspect-video w-full object-cover opacity-50" alt="" />
                <div class="p-4">
                    <a class="text-xl font-medium text-gray-300">${job.name}</a>
                    <p class="text-xs font-medium text-gray-500">${job.description}</p>
                    <div class="mx-auto max-w-lg">
                        <ul class="list-disc text-sm text-gray-600 opacity-85 h-40 overflow-hidden list-none bg-slate-800 px-2 py-1.5 mt-5 rounded-md">
                            <h1 class="font-semibold text-gray-300 mb-1 text-base">Job Instructions</h1>
                            <li class="font-medium">${job.instructions}</li>
                        </ul>
                    </div>
                    <div class="mx-auto max-w-lg">
                    <ul class="list-disc text-sm text-green-900 bg-opacity-85 h-[140px] overflow-hidden list-none bg-emerald-200 px-2 py-1.5 mt-5 rounded-md">
                            <h1 class="font-medium text-green-800 mb-1 text-base">Paid Actions</h1>
                            ${job.paidActions.map((action) => `<li class="font-medium">${action}</li>`).join('')}
                        </ul>
                    </div>
                    <p class="overflow-hidden mt-5 text-gray-500 font-semibold text-sm">If this job is something for you, click the button and start working as ${job.name}.</p>
                    <button type="button" class="mt-2 rounded-md border-gray-700 bg-slate-800 px-4 py-2 text-center text-sm font-medium text-white transition-all hover:bg-slate-700 focus:ring focus:ring-gray-200 disabled:cursor-not-allowed disabled:border-gray-300 disabled:bg-gray-300 start-working-button" onclick="startJob(&quot;job&quot;, ${jobKey})">Start Working</button>
                    <div class="mt-4 flex gap-2">
                        ${job.tags.map((tag, index) => `<span class="inline-flex items-center gap-1 rounded-md ${config.tagColors[index]} px-2 py-1 text-xs font-bold text-stone-800">${tag}</span>`).join('')}
                    </div>
                </div>
            </div>
            `;
            $("#jobs-container").append(dynamicContent);
        });
        Object.entries(config.Licenses).forEach(([licenseKey, license]) => {
            var dynamicContent = `
            <div class="mx-auto max-w-md overflow-hidden rounded-lg h-[29rem] bg-slate-900 mb-10" style="display: none" id="license-${licenseKey}">
                <img src="./img/${license.image}" class="aspect-video w-full object-cover opacity-50" alt="" />
                <div class="p-4">
                    <a class="text-xl font-medium text-gray-300">${license.name}</a>
                    <p class="text-xs font-medium text-gray-500">${license.description}</p>
                    <h1 class="font-semibold text-green-200 mt-1 text-base">$${license.price}</h1>
                    <div class="mx-auto max-w-lg">
                    <p class="overflow-hidden mt-5 text-gray-500 font-semibold text-sm">If this job is something for you, click the button and start working as ${license.name}.</p>
                    <button type="button" class="mt-2 rounded-md border-gray-700 bg-slate-800 px-4 py-2 text-center text-sm font-medium text-white transition-all hover:bg-slate-700 focus:ring focus:ring-gray-200 disabled:cursor-not-allowed disabled:border-gray-300 disabled:bg-gray-300 start-working-button" onclick="startJob(&quot;license&quot;, ${licenseKey})">Buy License</button>
                </div>
            </div>
            `;
            $("#licenses-container").append(dynamicContent);
        });
        showJob(currentJob);
    }
});

$("#up").on("click", function (event) {
    const selectedCategory = $("#categorySelect").val();
    if (selectedCategory === "jobs") {
        const nextJob = (currentJob + 1) % config.Jobs.length;
        showJob(nextJob);
    } else if (selectedCategory === "licenses") {
        const nextLicense = (currentLicense + 1) % config.Licenses.length;
        showLicense(nextLicense);
    }
});

$("#down").on("click", function (event) {
    const selectedCategory = $("#categorySelect").val();
    if (selectedCategory === "jobs") {
        const prevJob = (currentJob - 1 + config.Jobs.length) % config.Jobs.length;
        showJob(prevJob);
    } else if (selectedCategory === "licenses") {
        const prevLicense = (currentLicense - 1 + config.Licenses.length) % config.Licenses.length;
        showLicense(prevLicense);
    }
});

$("#categorySelect").on("change", function () {
    const selectedCategory = $(this).val();
    if (selectedCategory === "jobs") {
        $("#jobs-container").show();
        $("#licenses-container").hide();
        showJob(currentJob);
    } else if (selectedCategory === "licenses") {
        $("#jobs-container").hide();
        $("#licenses-container").show();
        showLicense(currentLicense);
    }
});

const showJob = (jobIndex) => {
    $(`#job-${currentJob}`).css("display", "none");
    currentJob = jobIndex;
    $(`#job-${currentJob}`).css("display", "block");
}

const showLicense = (licenseIndex) => {
    $(`#license-${currentLicense}`).css("display", "none");
    currentLicense = licenseIndex;
    $(`#license-${currentLicense}`).css("display", "block");
}

const startJob = (_type, jobIndex) => {
    $('html, body').css('display', 'none');
    $.post(`https://${GetParentResourceName()}/select`, JSON.stringify({
        type: _type,    
        job: config.Jobs[jobIndex].rank,
        license: config.Licenses[jobIndex],
    }));
}

document.onkeyup = function (data) {
    if (data.which == 27) {
        $('html, body').css('display', 'none');
        currentJob = 0;
        currentLicense = 0;
        $("#jobs-container, #licenses-container").empty();
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }
};