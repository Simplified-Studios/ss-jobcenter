Config = {}

Config.Main = {
    useTarget = 'qb', -- 'qb' , 'ox' , or 'lib' target / draw text UI
    Locations = {
        ["jobcenter"] = {
            coords = vector4(-269.19, -956.09, 31.22, 206.34),
            model = "s_m_m_armoured_01",
            blip = {
                sprite = 407,
                color = 4,
                scale = 0.7,
                label = "Job Center",
            },
        },
    }
}

Config.Jobs = {
    {
        name = "Garbage Job",
        image = "garbage.jpg",
        rank = "garbage",
        description = "Learn more about the lowest earning job here.",
        instructions = "A garbageman, also known as a sanitation worker, is responsible for collecting and disposing of municipal waste. Their duties include driving garbage trucks along designated routes, picking up trash bins or bags, and ensuring proper waste disposal. Garbagemen play a crucial role in maintaining public health and sanitation standards within communities.",
        paidActions = {
            "Waste Collection",
            "Route Efficiency",
            "Specialized Waste Handling",
            "Overtime Pay",
            "Public Interaction"
        },
        tags = { "Driving", "Low Salary", "Lonely", }
    },
    {
        name = "Taxi Job",
        image = "taxi.jpg",
        rank = "taxi",
        description = "Learn more about the lowest earning job here.",
        instructions = "A taxi driver provides on-demand transportation services to passengers within a specific geographic area. Responsibilities include picking up passengers, navigating efficiently to destinations, and processing fares. Taxi drivers often work independently or for taxi companies, earning income through a combination of fares and tips.",
        paidActions = {
            "Passenger Transport",
            "Waiting Time",
            "Additional Services",
            "Peak Hour Rates",
            "Tips"
        },
        tags = { "Driving", "Low Salary", "Lonely", }
    },
    {
        name = "Truck Job",
        image = "trucking.png",
        rank = "trucker",
        description = "Learn more about the lowest earning job here.",
        instructions = "A trucker, also known as a truck driver, operates commercial vehicles to transport goods over long distances, ensuring timely and safe delivery. Responsibilities include navigating routes, adhering to traffic regulations, and maintaining the vehicle. Truckers play a crucial role in the logistics and transportation industry.",
        paidActions = {
            "Freight Transportation",
            "Loading and Unloading",
            "Adherence to Schedule",
            "Specialized Skills Pay",
            "Overtime Pay"
        },
        tags = { "Driving", "Low Salary", "Lonely", }
    },
}

Config.tagColors = {
    "bg-green-300",
    "bg-rose-400",
    "bg-orange-200"
}