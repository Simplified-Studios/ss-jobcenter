let currentJob = 0;

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
                    <button type="button" class="mt-2 rounded-md border-gray-700 bg-slate-800 px-4 py-2 text-center text-sm font-medium text-white transition-all hover:bg-slate-700 focus:ring focus:ring-gray-200 disabled:cursor-not-allowed disabled:border-gray-300 disabled:bg-gray-300 start-working-button" onclick="startJob(${jobKey})">Start Working</button>
                    <div class="mt-4 flex gap-2">
                        ${job.tags.map((tag, index) => `<span class="inline-flex items-center gap-1 rounded-md ${config.tagColors[index]} px-2 py-1 text-xs font-bold text-stone-800">${tag}</span>`).join('')}
                    </div>
                </div>
            </div>
            `;
            $("#dynamicContentContainer").append(dynamicContent);
        });
        showJob(currentJob);
    }
});

$("#up").on("click", function (event) {
    const nextJob = (currentJob + 1) % config.Jobs.length;
    showJob(nextJob);
});

$("#down").on("click", function (event) {
    const prevJob = (currentJob - 1 + config.Jobs.length) % config.Jobs.length;
    showJob(prevJob);
});

const showJob = (jobIndex) => {
    $(`#job-${currentJob}`).css("display", "none");
    currentJob = jobIndex;
    $(`#job-${currentJob}`).css("display", "block");

    $("#down").html(`
        <svg class="w-3.5 h-3.5 me-2 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5H1m0 0 4 4M1 5l4-4"/>
        </svg>
        ${config.Jobs[(currentJob - 1 + config.Jobs.length) % config.Jobs.length].name}
    `);
    $("#up").html(`
        ${config.Jobs[(currentJob + 1) % config.Jobs.length].name}
        <svg class="w-3.5 h-3.5 ms-2 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
        </svg>
    `);
}

const startJob = (jobIndex) => {
    $('html, body').css('display', 'none');
    $.post(`https://${GetParentResourceName()}/startJob`, JSON.stringify({
        rank: config.Jobs[jobIndex].rank,
    }));
}

document.onkeyup = function (data) {
    if (data.which == 27) {
        $('html, body').css('display', 'none');
        currentJob = 0;
        $("#dynamicContentContainer").empty();
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }
};