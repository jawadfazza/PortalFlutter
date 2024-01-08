import 'package:flutter/material.dart';
class Constraint {
   static Map<String, IconData> iconMapping = {
    '2c0d01b9-3fb8-4028-afa9-2bdf0daf5969': Icons.phone_android,
    '18648f86-4d17-4a24-a519-ec36ebf1c5a6': Icons.accessibility,
    '8c4b1276-0799-403b-8cbf-5a8d02d0fda3': Icons.menu_book,
    '4884bcf5-842d-42fa-9a8e-08053a820b8d': Icons.kitchen,
    '862d16ef-eac5-4bc0-a70b-4ca7e1d38bc7': Icons.sports_soccer,
    'd06e4bbb-26a7-45c4-9d0e-3fc5957e4989': Icons.face,
    'c87368a5-a1ed-4917-912b-3200808a0c04': Icons.weekend,
    'dac985c6-73bf-41c0-9344-626a6b16884d': Icons.toys,
    '47816aae-3164-4cf1-ab63-f7b169f3543d': Icons.fastfood,
    'e2969f69-aca4-43e2-ba03-38e706a368ba': Icons.favorite,
    '1320a879-0718-48bb-b725-2e81ca6577c8': Icons.directions_car,
    '9690d4c7-e402-4de8-85d0-2e825badd129': Icons.work,
    '72d258ef-aab1-406b-8a61-21183ba8c922': Icons.home,
    '633373bf-193e-4ecf-a3ef-8183b0f7546e': Icons.eco,
    '5330a4e9-3368-4359-9be9-ab2979d21a15': Icons.shopping_bag,
    '31cd1243-b9a0-4fc3-bbe8-89c2b5f1fdf2': Icons.child_friendly,
    '1c04e7d1-fe7a-40c1-89e7-018ca80616ee': Icons.card_travel,
    '73f88d46-7425-47ab-9779-91509627d701': Icons.fitness_center,

  };
    static Map<String, IconData> subIconMapping = {
    'c8838737-7996-4a37-af30-58292fab29ae': Icons.palette, // Art and Photography
    '335a1105-aa76-4265-9eb9-a604787c8e64': Icons.book_outlined, // Biography
    '9f338571-8cd1-490a-a853-d6d53aa8d9db': Icons.child_care_outlined, // Children's Books
    'c0eacd32-ec0a-4317-8a3a-93fb870f9d05': Icons.local_dining_outlined, // Cookbooks
    'd092250b-827f-4650-9d1d-93328236c049': Icons.book_outlined, // Fantasy
    '4d1e926b-d775-4d10-83df-4c4328fd37ee': Icons.book_outlined, // Fiction
    '5cbaae2b-9240-4dbe-83ae-b59ed7d7ca86': Icons.history_edu_outlined, // History
    '7a36b792-3034-47ca-bbc1-792424522388': Icons.search_outlined, // Mystery
    '7e60cacf-b454-4ed5-a4ca-3e0f4d00de7d': Icons.library_books_outlined, // Non-Fiction
    'f4052853-936e-46af-8f7f-58d7b4b0234b': Icons.museum_outlined, // Poetry
    '0fa967a5-bb25-4c1d-b55d-98125e22e5d2': Icons.family_restroom_outlined, // Religion
    '3a968c66-514c-419f-a292-dffff56e810f': Icons.science_outlined, // Science Fiction
    'b02ab39d-6759-4bf9-af72-3c886ff925d1': Icons.self_improvement_outlined, // Self-Help
    '4488d0d3-0b7b-4c6b-affb-a56a04e230ff': Icons.airplanemode_active_outlined, // Travel Guides
    'e58ea6e6-6939-42cf-8687-b32c4ac5b600': Icons.mood_outlined, // Young Adult
    'ec424115-594b-40d0-aea5-35611c6947e4': Icons.directions_bike,
    '46d365ab-ea57-4c5f-8611-04179617baed': Icons.build,
    '7ae6c553-73be-47e2-abe0-0a80ed867778': Icons.weekend,
    'a8703e26-eaff-4b27-b050-db7303f063de': Icons.accessibility,
    'd7d20364-1281-4872-a9e8-eb7ec7d48a75': Icons.account_balance_wallet,
    '3489a547-3476-4382-9917-2c503c9d85e9': Icons.directions_run,
    '83395482-a097-4150-9b3c-c159006f919c': Icons.directions_bike,
    '1de3d4cc-4d53-46b5-bc0b-e3c28c32d69e': Icons.accessibility_new,
    '25ba6cb3-c39e-4ded-acdf-de6161e4539e': Icons.ac_unit,
    '90a988e8-a40f-40ae-a5e3-d59579946fc4': Icons.anchor,
    '1b2d0c47-beea-4316-ba11-d98fd7567434': Icons.create,
    'c846a5b3-789c-482f-8aa7-1123026c589f': Icons.palette,
    '93b0e62c-92aa-432a-925c-895b412a7a9f': Icons.watch,
    '24995296-5896-41f2-af0b-58505d3835a9': Icons.audiotrack,
    'f23215e5-37b7-48b7-95c8-5c5ca1c6e18b': Icons.audiotrack,
    'c84170b6-97a4-4af0-8a04-91b367cdfcf0': Icons.directions_car,
    '088cad1a-065a-4750-907c-10b33d2bde2f': Icons.directions_car_filled,
    'f449e2e0-2287-431a-8066-7af3127b0f5f': Icons.bathtub,
    '8bf6329b-e7c7-4e25-8b4a-458771900906': Icons.local_hotel,
    '446b6d20-8477-4164-9dd7-e4f4168312b2': Icons.book,
    '98ce036b-9e89-45f0-9ebb-e21a9e1e31e9': Icons.child_care,
    '5457775e-3415-4cc6-b352-6f9ad93779e4': Icons.emoji_food_beverage,
    'adc65b19-40c5-4189-9f30-5af7789796e8': Icons.fastfood,
    'c80d3e45-9694-423c-b99c-f1b5093ed495': Icons.baby_changing_station,
    '063f5139-bfa4-428b-b744-11ec872b8635': Icons.child_friendly,
    'cd89c697-79fd-43ce-88b5-cf6188a29660': Icons.child_care,
    'b827bb57-4010-44e8-b9d9-9c2952dcd348': Icons.toys,
    '92073237-cfd7-4f3f-bda9-1fdc639261aa': Icons.car_rental,
    '58cfef5d-8f93-470f-b30c-4baa29e0de51': Icons.backpack,
    '110f3f5d-447b-437f-bb85-d877bc9079f3': Icons.kitchen,
    '5d2ccd3d-8a81-4586-9a46-b6f65b32035f': Icons.bathtub,
    'df380192-b492-46ba-97a7-2b8a4701daef': Icons.bathtub,
    '5f40491c-1777-4936-ad6b-de756264bde1': Icons.accessibility,
    'fb820152-cf00-4f23-9243-2962acf8d023': Icons.king_bed,
    'ee756ce0-c20c-47d2-970c-670794218dcc': Icons.accessibility,
    'c771fc1c-2a79-433f-8136-7676f9f1fc2c': Icons.accessibility,
    '92dfc9f2-1bda-4c1f-a951-35361ae5c385': Icons.local_drink,
    'f8f6bbcc-3a19-45fc-a661-dc1f2b38aa7d': Icons.directions_bike,
    '6bf30f41-9b33-4d9d-8161-5abb974cea52': Icons.bookmark,
    '8e7be88c-b7a2-43b8-a1b2-3cf907ab08e2': Icons.blender,
    '6bb84d16-f6b6-4ed2-a3b4-06feb5829d67': Icons.games,
    '237c63fa-36fa-4a35-bdfd-f3433ea52322': Icons.directions_boat,
    'dfabeffc-13bf-40f7-9bb1-cb1244ade086': Icons.directions_boat,
    'bc9c476c-81df-4189-ad6a-b91f2204a2d0': Icons.palette,
    'fc181c12-6b97-4e5e-bc5e-92be0204f723': Icons.view_list,
    'd3ea13c2-857c-40b2-b5fe-f646a9b1496f': Icons.accessibility_new,
    'a6971f53-827c-49a1-969c-ed228cc93248': Icons.accessibility_new,
    'e9418c95-2f85-4735-be18-7506219340eb': Icons.extension,
    '9e2d5681-976b-4b2c-9307-de406b99a046': Icons.calculate,
    'eff65c88-b61c-4b8e-8fa7-d81a53d7eb99': Icons.date_range,
    '91cbac99-e1f3-44b6-99b6-70d19e02a963': Icons.camera_alt,
    '807ff80f-b032-4ff5-ab96-9e35d7502c87': Icons.camera_alt,
    'ca01cc5f-1fc9-49a5-b113-5949f9542f03': Icons.question_mark,
    '47ff3991-a4cf-4c92-9b39-6f9771dbe22e': Icons.lightbulb_outline,
    '773fdc41-971d-48aa-b377-d1246cb5e438': Icons.food_bank,
    '82d1d9f6-0eac-4258-8428-fe7ab052283a': Icons.directions_car,
    '960026a4-135c-4758-9fca-27a73680ff66': Icons.directions_car,
    'c860f1cb-85eb-46d4-b7d9-8d8a966ed28e': Icons.directions_car,
    '4cb7f070-c5c6-496f-b07d-5db32e5108c4': Icons.fitness_center,
    'a5cbf62c-7218-4d9b-bf1b-bc6fc8b5ac33': Icons.accessibility,
    '08ca0ac7-d370-4d7a-bcc0-31c4a6643f13': Icons.accessibility,
    'c85d6ab4-2c58-461e-832b-b02c44f8544d': Icons.accessibility,
    '188ce984-5cc6-45f4-8ef5-559cd2f1846b': Icons.accessibility,
    '055ad375-7250-45a7-9bd8-2efbe615708c': Icons.access_time,
    '415bbcef-8f75-42d6-8d8a-500c8580f206': Icons.local_cafe,
    '901cbc9a-7a61-4dca-be3e-b109ec54ed9d': Icons.computer,
    'd738661f-cf16-42fb-a8ea-6735c0e9f7ef': Icons.computer,
    '6d414e2c-4d2a-4058-a7bf-ae08da82398f': Icons.construction,
    'cc884a40-5e2e-4ac2-8864-0e58b5c75ab5': Icons.kitchen,
    '698380f2-1678-46c9-9e7a-485c6a8e4609': Icons.accessibility,
    '029492c9-0b71-4cac-bda9-04b3e901069b': Icons.web,
    '6f12360d-388a-47fd-94e5-a95a8dc9b320': Icons.local_grocery_store,
    'c538ddf9-7df8-4a5c-947b-099bf41c0a65': Icons.dehaze,
    '61f79ab3-2697-4e64-b104-339f808ca83a': Icons.accessibility,
    '35823613-10ba-446a-a516-c490cc6a11be': Icons.accessibility,
    'c388cee1-d066-4b2f-a7f4-b4584280afcf': Icons.desktop_windows,
    'e993c8bc-7114-4de4-a957-445a7ae96ff5': Icons.desktop_windows,
    'e8f18b18-e3e5-4f40-ac1c-e2a3a1b05e4c': Icons.local_hotel,
    '50b19164-5df3-4006-9418-c51f10be2f3d': Icons.weekend,
    '576e7254-919c-45f0-8195-96ac10fa8dea': Icons.kitchen,
    '26a467a4-5df3-4790-84f4-003430e33b8f': Icons.question_mark,
    'd78eb08a-ea35-4661-997a-b0ed2d327b1a': Icons.accessibility_new,
    'ac4ed368-ee28-4215-8a0e-cba3daa30241': Icons.accessibility_new,
    '90a5be5b-6731-49e3-813f-7ba1c4eb00b2': Icons.school,
    '44d6b06a-3938-4da8-9abc-f99b7cb5672e': Icons.gamepad,
    '82e75fa1-d829-4a93-a153-27859da4dc3c': Icons.weekend,
    'b40a9471-f227-4cfa-a0ad-f5eb52cccaac': Icons.local_post_office,
    '1c20d7c1-6ae7-46fb-9440-87933e784e1c': Icons.fitness_center,
    '3ee1b78d-a500-4951-8c56-90c41dcb7b25': Icons.fitness_center,
    'ba4c0607-ea15-4edc-87cb-7bb057e2e2c1': Icons.fitness_center,
    'e477fe66-5dbf-4038-a77e-bac68ba113f3': Icons.accessibility_new,
    '50d07223-504a-4f46-bb8f-28d0c136ed4a': Icons.border_clear,
    '7d3ae66a-c8c1-4540-8892-ef6de904d9de': Icons.folder,
    '0804113d-ae13-4a8e-b818-b27a7466283c': Icons.local_hospital,
    '11d40b7f-326e-47ad-a407-0fe65f9a82c9': Icons.accessibility_new,
    'f65a051b-3c5e-4f49-88e2-04b01e125140': Icons.menu_book,
    '347e0f60-b74c-4e16-bcc3-26f8589a43d0': Icons.fitness_center,
    '6d5d0502-7afe-491d-aecc-8932189dce20': Icons.fitness_center,
    'a1921d3f-557d-45d3-bf7f-132171774a02': Icons.healing,
    '27627154-5fee-4660-8a8c-aea4303308b5': Icons.fitness_center,
    '27813766-9561-457a-b5f4-e309bd38830d': Icons.fitness_center,
    '51e7e3da-a7fb-4318-8fb1-01052f57b26f': Icons.directions_run,
    'b2880686-f56f-4bde-bad7-002dd6476566': Icons.kitchen,
    'ce763303-6cb3-45e8-8535-741d87268024': Icons.videogame_asset,
    '7406d8b8-7595-4afb-bcab-61c2dee6a8b0': Icons.icecream,
    'eb79b9c8-4e7c-4fa8-ac59-8210b7b1f58d': Icons.weekend,
    '420b624a-10c2-49e2-98f7-ece97db3760f': Icons.sports_esports,
    '70dac10a-eb85-4a25-83ca-b1b1cac96978': Icons.sports_esports,
    'eca6de2f-4050-4d72-937f-1022aa79d0a8': Icons.local_florist,
    '1146191e-bb2b-47b5-b33b-9ee1668d3cec': Icons.build,
    '98360f84-f4b7-45e3-8cf3-d344ffbb7a75': Icons.accessibility_new,
    '8ae7b9cc-6055-42d8-9075-ccebadb2fba6': Icons.accessibility_new,
    '6f656d58-6348-4222-bf76-25310f3f15f5': Icons.golf_course,
    '9ed239c6-07b5-47a3-a506-c934033bc29d': Icons.fastfood,
    '9716ef1a-e0ac-4ed0-94f4-5dfd181affa2': Icons.question_mark,
    '162a16b7-f109-4f8f-ac60-acfd097c9294': Icons.accessibility,
    'bf447ceb-64d2-420e-9db2-5b143fc844c0': Icons.access_alarm,
    'ec435e98-eab0-4418-8c24-af5b9ab8ae6f': Icons.category,
    '9782efde-4a30-43da-bcfd-8359b4cee142': Icons.category, // Assuming same icon as previous
    'd4a7f44b-c424-4e9f-9cf9-5aab980a73a7': Icons.book,
    '3701ceab-789b-4bdb-a826-9961df6e475b': Icons.food_bank,
    '06f45c81-a2c8-47a0-a89d-692a9035450d': Icons.favorite_border,
    '76e18242-8e7c-460c-aaca-71cc299afb37': Icons.directions_walk,
    '75add43a-0dfb-48f0-9ff0-26dcc04ca42a': Icons.party_mode,
    '6816d032-93b6-4e11-8fd4-6a652afc228d': Icons.kitchen,
    'ec99e9ce-52a6-41c0-aa9c-1574089b850b': Icons.kitchen,
    '70bbbcdb-8cc7-4fb7-bb31-62e38f977ab2': Icons.tv,
    'fcedcdcc-8630-4ac9-a6e9-a39470d687f9': Icons.shutter_speed,
    '8dcea448-2853-4e2c-90c6-d0c9d4a7eb49': Icons.fitness_center,
    '3334fcd8-2d70-4ec1-9d1c-6db476dec763': Icons.home,
    'fb937079-7266-4156-b9bf-8380fe9a1abe': Icons.home,
    'fcec7f8f-900c-40b7-83b8-be97c5e9beb6': Icons.question_mark,
    'e8ea67c9-3093-4d30-83e3-a8c843eaed9c': Icons.bathtub,
    'a00c78b7-6d95-4f63-873c-2afd0c71d451': Icons.eco,
    '3a328e9d-f980-4986-9913-d563bd55bf46': Icons.iron,
    '4586f018-58d6-40ec-92ee-ec11ee818a6c': Icons.food_bank,
    '046d26e1-d9ca-4af2-a6b6-fa514dacee1f': Icons.child_care,
    'ebfea52b-e4ae-4702-9154-c0b43db2e8cf': Icons.child_friendly,
    '4582f525-cfdb-4c1f-949d-637c5fc9ab26': Icons.child_care_outlined,
    '906ea401-1335-4917-993d-5845a34238ba': Icons.question_mark,
    '61a349e5-2177-474c-97da-b690ce409f38': Icons.child_friendly_outlined,
    'f5cd95fc-42d2-40e5-839d-6f4515a6bea0': Icons.toys_outlined,
    '698fee9e-05f7-4028-86e8-03cc180673c1': Icons.toys,
    'fa22f7e9-5c47-4805-822e-ab1fe059bbf6': Icons.label_outlined,
    'de0f1c04-a730-4e2e-814c-935f8f40f893': Icons.landscape_outlined,
    '329636f5-eecf-42ae-80e7-7730137d20e3': Icons.laptop_outlined,
    'a1e5babb-ff9e-42ad-b5fe-686542635790': Icons.laptop,
    '9446de5c-a91b-4fbe-a64f-feaf34ac6f14': Icons.question_mark,
    '70a92f12-bbd4-485d-8ce2-fcc8f0e243bc': Icons.leaderboard_outlined,
    '2a8248d0-7a27-410c-a0bf-e31bedd25ba8': Icons.living_outlined,
    'e310da04-feda-48d9-8095-29fd9417bfc7': Icons.pregnant_woman_outlined,
    'acc68d4f-08d3-44bf-a39b-0bbaf96e06e7': Icons.luggage_outlined,
    '9f50d045-0fed-4ee8-9b0a-047a1c7d6be6': Icons.tag_faces_outlined,
    '9cd2255c-6dce-4ce4-83fd-a54f18a9077e': Icons.brush_outlined,
    'f15682c7-c68b-44bc-ad9f-2a5c73123a01': Icons.waves_outlined,
    '8a68c17a-55ae-4578-b9df-49a5becfc382': Icons.pregnant_woman,
    '4da94f26-81a5-4559-9b1b-9e9df55bbbbd': Icons.pregnant_woman_outlined,
    '4ac8cf19-24e3-4d2d-a69c-61b671bd8e9b': Icons.local_hospital_outlined,
    'fcf6d7ac-dba8-498e-aabf-c512eff7d1e4': Icons.medical_services_outlined,
    'ed0adf63-7fd9-48c9-ba40-c35343f738b7': Icons.male_outlined,
    'e2da75d7-6086-4cf2-88fb-b19bb2385296': Icons.face_outlined,
    'ad52dc59-2e96-42e0-b63b-c4287cc379b6': Icons.psychology_outlined,
    'f1165a25-7daa-43d8-b336-41a4a55d7031': Icons.microwave_outlined,
    'b6788bf5-2732-430c-a23a-193795dab0dd': Icons.account_balance_outlined,
    '4da8632b-8ac5-4c89-baa6-591b4773956e': Icons.style_outlined,
    '19d1a2e6-cf24-4921-b82f-ada1d9fe2aa1': Icons.fullscreen_outlined,
    'a7ab5689-9e5f-4f85-95de-4fa568dc6092': Icons.motorcycle_outlined,
    '547ec431-1688-4cf5-8dcd-b0f13b94d37e': Icons.motorcycle_outlined,
    '8577f8d9-6b88-40c2-92b9-93a662214bbb': Icons.healing_outlined,
    '6a60a66e-42d7-4716-a18e-8bfae0d0ad52': Icons.accessibility_outlined,
    '23d05004-5265-4801-b614-9222c979d60a': Icons.router_outlined,
    'a30fb12a-6bbb-4a2b-8c1f-3e163f891c98': Icons.router,
    '764af9b9-d6af-41a8-b260-a887bab18b83': Icons.child_friendly_outlined,
    'bb951042-a867-4fbe-adb9-6c86adced5d8': Icons.restaurant_outlined,
    '1e17d332-0f30-4ff0-827d-b00b2ed8059e': Icons.device_hub_outlined,
    '0cb9ff35-e938-4373-9df1-c35fafdb24f0': Icons.meeting_room_outlined,
    '25a3ab31-e5bd-410f-9343-a440a27b2a32': Icons.meeting_room_outlined,
    '074e0425-b42b-4c25-8716-fbc41d2b26c7': Icons.male_outlined,
    'b47d46af-505d-4103-ae51-66108dd90285': Icons.male_outlined,
    'a04e02bf-c94e-4ec9-8787-6d2023fc62eb': Icons.wc_outlined,
    'f8c57c5c-6348-4b1d-8270-0b4ded542e93': Icons.outdoor_grill_outlined,
    '6bedff3b-b269-41cc-b99d-f892ab94e10e': Icons.outdoor_grill_outlined,
    'd3fc74af-c68d-48a0-87d3-dfbc6ecf9b11': Icons.chair_outlined,
    '054f4eb1-c6bd-4bf8-a362-c242a938a816': Icons.lightbulb_outlined,
    'b979d148-1b4f-4b8e-bd7d-daf69c8de2e5': Icons.gamepad,
    '8841010e-d9df-43f8-b32a-73b91866a206': Icons.power_outlined,
    'b149d9be-3181-4a46-80c4-c9976eb82909': Icons.directions_bike_outlined,
    '53db0e65-828c-4b48-ba73-79f42a1a1c68': Icons.question_mark,
    'c09a0084-956e-4edf-8a96-a71100b38ad5': Icons.question_mark,
    '9d1e78b0-a733-4277-8092-29e035d317f4': Icons.file_copy_outlined,
    'bb5fbc00-eead-40bf-969e-7dcf5a5c4577': Icons.celebration_outlined,
    '755f3078-560f-4f87-805a-df3469a00d67': Icons.card_membership_outlined,
    '0275f51b-5898-4cda-8fbd-8b427e2e0aa4': Icons.deck_outlined,
    '1e0edfb1-8181-4776-ae91-6a458e6923a6': Icons.person_outlined,
    '78b41696-4919-40cb-aa9e-e0d304051767': Icons.person_outline_outlined,
    '8f94f212-a4fd-4435-bcf2-f750d28f9260': Icons.question_mark,
    'd5615035-8139-437e-94ab-bb9a12145577': Icons.photo_outlined,
    'a16af852-bb61-49c4-8a4b-6b9507a8c65a': Icons.bed_outlined,
    '95719ef8-5e6e-4d9d-9476-ccc8b54a3f0b': Icons.eco_outlined,
    'e1e233df-f0d6-4c86-84fd-99c10d6310be': Icons.pool_outlined,
    '733ad207-21f5-4287-90f5-774c8121c206': Icons.question_mark,
    '8bd47b08-b983-4adf-880f-070547938ae8': Icons.print_outlined,
    '871d23e2-5b4e-4da8-a2db-473d7da02ccf': Icons.extension_outlined,
    '869daa09-0e12-4610-9675-83e1feb8396f': Icons.local_shipping_outlined,
    '62f42459-1ca5-4382-a087-2c3506a73a9c': Icons.local_shipping_outlined,
    '191b6506-5d41-4c3e-840c-6134b897fe16': Icons.kitchen_outlined,
    'b1be191e-7b9d-4721-b7a7-4c03eb0c8c42': Icons.accessibility, // Religious Clothing
    '27de2da6-c3ba-4756-babb-00bddefffef7': Icons.toys_outlined, // Remote Control Toys
    'da68bae7-c75c-451a-8c41-41322476a570': Icons.fitness_center, // Resistance Bands
    '1cc9b0dc-27f8-4200-8da8-26918db84c8d': Icons.kitchen, // Rice Cookers
    'ca20e594-f7c5-4449-8081-d9edf089b75c': Icons.directions_car, // Ride-On Toys
    '1748df99-9413-4e8a-9de4-3daebea42734': Icons.question_mark, // Rings
    'a020e2b8-53ed-4adf-9b1b-94dbd627ffd9': Icons.house_outlined, // Rugs and Carpets
    '83283cbe-220f-41fe-8b0c-8493b5e5ea87': Icons.restaurant_outlined, // Sauces and Condiments
    '18c74f8c-2af7-4250-a909-2160a063474c': Icons.wrap_text, // Scarves and Shawls
    '2468d452-b585-459a-b6a1-b3154348b2ac': Icons.wrap_text, // Scarves and Shawls
    '12935eb2-949c-4d8b-bc6e-2c930689c621': Icons.insert_emoticon, // Sculptures and Figurines
    'cfb52e03-8a6b-4934-8a9a-70a16d0c0af7': Icons.person, // Senior Clothing
    'ba737f50-b624-43d5-8acc-732f7499cf47': Icons.storage, // Sheds and Storage
    '485afb2f-0b13-45e8-8b94-f661e956d4a8': Icons.local_shipping, // Shipping and Packaging
    '6cd9ec14-fcdf-4bf0-8bc1-70986bd274db': Icons.directions_bike, // Skateboarding and Scooters
    '1770fb59-fe62-4986-8965-30a2747ee5b6': Icons.spa_outlined, // Skin Care
    '9d782c76-e1a1-4c1c-9616-b12e96815bcf': Icons.spa_outlined, // Skin Care
    '819e6743-c71a-4cfe-90ce-5bb0f3b5149c': Icons.nightlife, // Sleepwear
    '3122c58f-8f0e-4630-acf7-b4782e11fcb1': Icons.smart_display_outlined, // Smart Home Devices
    '082f8e4d-7614-496c-a89e-728ed8b0e7ee': Icons.smart_display_outlined, // Smart Home Devices
    'dd09ca81-7f5f-42d3-be77-65d7ac3dba9d': Icons.phone_android, // Smartphones
    'ae137f97-479b-48c9-900a-27f9ed0fa6f9': Icons.phone_android, // Smartphones
    '554f259c-69aa-4b42-b4b7-2fbe856b0ba5': Icons.fastfood, // Snacks
    'b5c47b2d-f81b-4956-ac99-acb5b67b53fd': Icons.shopping_bag_outlined, // Special Occasion Clothing
    '2b56795e-ae5e-409e-b461-6d31bef04ca4': Icons.local_florist, // Spices and Seasonings
    '39a87460-18cf-43e0-a0f5-874b7b3af6b2': Icons.fitness_center, // Sports Nutrition
    '16dbe304-fd1c-4195-a5c7-e3e2b14d63a7': Icons.sports_football, // Sports Shoes
    '02be6239-7b9d-45a4-80bb-8b7746f215e5': Icons.directions_run, // Sports and Athletic Wear
    '4ff78d72-4b77-4aab-9277-8bd07a24016a': Icons.wb_sunny, // Spring/Summer Clothing
    'e9562fcd-367d-4c66-83ce-1c802c9eafaa': Icons.mark_email_read, // Stamps and Stamp Supplies
    '4516dc33-ef1a-49e1-a437-557ed13c8e84': Icons.attach_file, // Staplers and Punches
    '9255b0e6-2f98-46d5-8d81-482c0af3db05': Icons.storage_outlined, // Storage Furniture
    '122a2ba7-7f0d-4830-ac73-f2788df98de9': Icons.directions_walk, // Streetwear
    'd8a4033c-94dc-4779-8190-f62ea1f65278': Icons.fitness_center, // Strength Training
    '3e71a367-9f7f-484e-990e-1b453467bfac': Icons.toys_outlined, // Stuffed Animals
    '417ed6ce-6c13-4873-8b1c-910de8273e6f': Icons.visibility, // Sunglasses
    '1c20ceab-5e99-443e-a9bb-1c16021be672': Icons.cake_outlined, // Sweets and Desserts
    '94b7947b-6c2a-4205-a759-39829688b592': Icons.waves_outlined, // Swimwear
    'c5bd32b5-9835-4989-bad4-ac476a8763ac': Icons.wb_cloudy, // Synthetic Fabric Clothing
    'f9d97868-ee3a-4591-b9fd-0b3cf9b453f2': Icons.tablet_android, // Tablets
    '466acab2-ea26-4ae5-bad1-8bfcd2e457ec': Icons.tablet_android, // Tablets
    'fc623bb2-6520-465a-85c6-4735a78204c2': Icons.local_cafe_outlined, // Tea and Coffee
    '7d5a80a7-e78d-433a-ae0c-2f052c1aaf46': Icons.sports_soccer, // Team Sports Gear
    '1146d272-d21b-4e78-961a-d69b7782b388': Icons.person_outline, // Teen Clothing
    '83fd102c-04ca-4efd-9232-1c22f4afcbce': Icons.tv_outlined, // Televisions
    'a7d5bc74-5173-45c2-83c3-20a40cf79456': Icons.tv_outlined, // Televisions
    '56bbc470-823f-4765-bfbd-d9e2c080bf4a': Icons.weekend, // Throws and Blankets
    'a4e7fe13-731f-41e2-acdc-78ca267c3e04': Icons.adjust_outlined, // Ties and Bowties
    '751e08d1-c42f-451f-ba0e-86cf3e1edeba': Icons.adjust_outlined, // Ties and Bowties
    'f7eac861-c08c-448f-90de-c6d2e2d125d0': Icons.directions_car, // Tires and Wheels
    '6cf892df-5164-4372-a57a-f914c0e53af2': Icons.local_dining, // Toasters
    'f4eaf497-ce82-4dd9-be0c-51d93e1b216d': Icons.build, // Tools and Equipment
    '659a1f6d-ee26-48bb-ab7e-6c4758452054': Icons.card_travel, // Tops
    'e2894d49-1bfc-4146-902e-cb77d1ec574d': Icons.format_color_fill, // Traditional Clothing
    'da0ce71a-8c18-4afd-a33c-dccd50e57ed8': Icons.flight_takeoff, // Travel Accessories
    '75038863-dfb4-4007-86e5-11e27622398a': Icons.power_outlined, // Travel Adapters
    '4725c76d-91ca-4152-a709-041b360ead9f': Icons.card_travel, // Travel Bags
    '1a50a149-001c-4bd0-b1b8-1c884e3d453f': Icons.card_travel, // Travel Clothing
    '2f36ab72-9244-47e5-8377-2b4d1fcfd391': Icons.devices_other, // Travel Electronics
    '7861a8ad-5fa6-415e-bd2f-176ac2d32936': Icons.explore_outlined, // Travel Guides
    'af64931f-eece-402e-897a-6a39d6187f84': Icons.lock_outlined, // Travel Locks
    '2b218190-c013-454f-9215-02aef1662bcb': Icons.map_outlined, // Travel Maps
    '73a28f88-de4b-441a-8b3e-b58f13a87f55': Icons.format_list_bulleted, // Travel Organizers
    '6e940060-23af-44a5-b895-400aa02129d9': Icons.airplanemode_active, // Travel Pillows and Blankets
    '904cd975-54a9-4969-b803-39ccab80b01b': Icons.bathtub_outlined, // Travel Toiletries
    'f5c3f019-c930-49b8-808b-c15f4895432b': Icons.style_outlined, // Trendy/Fashion-forward Style
    '4b9a0a83-80a7-4115-bfe7-ae8d3beaa76b': Icons.local_shipping_outlined, // Truck Accessories
    'b4827454-6a62-48e9-a47d-3a52f9765cbd': Icons.car_repair, // Truck Parts
    'cb15a7f7-d537-48a5-bb17-33232a5ca700': Icons.grade_outlined, // Underwear
    'c94c449d-37f0-42b2-a5a4-d6c1c3ee3622': Icons.accessibility_new_outlined, // Unisex Clothing
    '44558a43-e0cb-4a87-992b-a2ea4e49d944': Icons.question_mark, // Vacuum Cleaners
    '0c40224d-ff23-4777-a908-b1e0bbe7ed88': Icons.question_mark, // Vases and Centerpieces
    '80140b9d-fad4-4213-98e1-9378cdb02dfa': Icons.videogame_asset_outlined, // Video Games
    '8b437aad-7c19-435d-92a7-c85eea90f9c3': Icons.format_paint_outlined, // Vintage Clothing
    'd17c4954-bbd2-4faa-aa7d-c36cb1fd9adf': Icons.healing_outlined, // Vitamins and Supplements
    'd0e9c8e7-0c84-43c5-9ed0-dc6a7f5df494': Icons.wallpaper_outlined, // Wall Art
    '55d350c2-0390-4f01-b1b2-3e89843552bf': Icons.account_balance_wallet_outlined, // Wallets and Purses
    'e5466529-cbf2-4922-ace6-f452f50bcd5d': Icons.question_mark, // Washing Machines
    'be48ad4d-e711-48a9-8016-f9c0a1dbe32d': Icons.watch_outlined, // Watches
    '6aab6c9f-8ef7-4bd5-956e-fed8c723f78f': Icons.hot_tub_outlined, // Water Heaters
    '33b9112c-1914-42c3-99f5-8c7543e4a97f': Icons.pool_outlined, // Water Sports Equipment
    'd4d54122-84cf-479c-b416-06bb599407fc': Icons.watch_outlined, // Wearable Devices
    '43bea03e-6106-41a9-9a85-964fe6ebcaf4': Icons.watch_outlined, // Wearable Devices
    'ada0f926-e3d3-4f25-9f13-4cc8e6d7cd90': Icons.local_fire_department_outlined, // Weight Management
    '5889fcf2-db1e-4782-83e9-fce06d22b3f4': Icons.healing_outlined, // Wellness Accessories
    'c5bb2e27-ed94-402a-ad44-3590b57ec0b8': Icons.assignment_outlined, // Whiteboards and Bulletin Boards
    'c9269ac4-9296-4357-aed0-39f86eb45a79': Icons.sports_tennis_outlined, // Winter Sports Gear
    '589f0ac2-541f-4f70-b71b-2b9ed27f0204': Icons.person_outline, // Women's Clothing
    '00d7757d-dd11-4d1d-a598-5f22c57365f6': Icons.filter_vintage_outlined, // Woolen Clothing
    '11a46d0a-8121-434e-8388-06d45e1f5268': Icons.local_movies_outlined, // Workout DVDs
    '78193f32-ae3c-4eba-b2b4-d18bbd2f696b': Icons.build, // Workwear
    '3206759d-04c6-445c-bfd8-b5e4a93ecd48': Icons.create_outlined, // Writing Instruments
    'a314ba90-eadf-4f62-b52a-c50fa0766752': Icons.self_improvement_outlined, // Yoga and Pilates
    'b72aaed3-d126-429d-b702-b67440d7233b': Icons.fitness_center_outlined, // Yoga and Pilates Equipment
    // ... Add more as needed
  };
}