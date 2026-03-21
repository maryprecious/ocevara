import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/fish_species.dart';
import 'package:ocevara/core/services/api_service.dart';

final speciesRepositoryProvider = Provider((ref) => SpeciesRepository(ref.read(apiServiceProvider)));

class SpeciesRepository {
  final ApiService _api;

  SpeciesRepository(this._api);

  Future<List<FishSpecies>> getAllSpecies() async {
    // Injecting professional mock data as requested
    final mockSpecies = [
      FishSpecies(
        id: 'tilapia-1',
        commonName: 'Tilapia',
        scientificName: 'Oreochromis niloticus',
        description: 'Tilapia is a common freshwater fish found in lakes, rivers, and ponds. It is an excellent source of protein and very popular for eating. Fast-growing and abundant.',
        habitats: ['Lakes', 'Rivers', 'Ponds', 'Fish farms'],
        imageUrl: 'assets/images/sign-up.png', // Brand background placeholder
        howToCatch: 'Tilapia are best caught using hook and line with small baits like worms or bread, or using cast nets in shallow waters.',
        isProtected: false,
        identificationTips: ['Silver or gray body', 'Deep body shape', 'Long dorsal fin', 'Red eyes in some types', 'Black stripe on tail'],
        sizeLimits: '15cm minimum. Can reach up to 40cm',
        bestSeasons: ['All year', 'Best: Dry season'],
        nutritionalValue: 'High in protein, low in fat, rich in vitamin B12',
        catchTechniques: ['Hook and line', 'Nets', 'Simple rod fishing'],
      ),
      FishSpecies(
        id: 'carp-1',
        commonName: 'Carp',
        scientificName: 'Cyprinus carpio',
        description: 'Common carp are large, hardy fish known for their strength and size. They are found in slow-moving or standing water and are popular in both sport and food fishing.',
        habitats: ['Lakes', 'Reservoirs', 'Slow rivers'],
        imageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=1000',
        howToCatch: 'Carp are opportunistic feeders. Use corn, boilies, or dough balls on a hair rig for the best results.',
        isProtected: false,
        identificationTips: ['Large scales', 'Two pairs of barbels on upper lip', 'Broad body', 'Golden-brown to olive color'],
        sizeLimits: '30cm minimum',
        bestSeasons: ['Spring', 'Summer'],
        nutritionalValue: 'Good source of Omega-3 fatty acids and Phosphorus',
        catchTechniques: ['Bottom fishing', 'Surface fishing', 'Feeder fishing'],
      ),
      FishSpecies(
        id: 'catfish-1',
        commonName: 'Catfish',
        scientificName: 'Clarias gariepinus',
        description: 'The African Sharptooth Catfish is highly resilient and can survive in low-oxygen environments. It is a prized food fish due to its firm, tasty flesh.',
        habitats: ['Muddy rivers', 'Swamps', 'Farm ponds'],
        imageUrl: 'https://images.unsplash.com/photo-1624821588183-27e182c6188a?q=80&w=1000',
        howToCatch: 'Best caught at night or in murky water using smelly baits like chicken liver or worms on bottom rigs.',
        isProtected: false,
        identificationTips: ['Whisker-like barbels', 'Smooth, scaleless skin', 'Large flat head', 'Dark gray to black back'],
        sizeLimits: 'No strict limit, usually 25cm+',
        bestSeasons: ['Rainy season', 'Night time'],
        nutritionalValue: 'Lean protein, rich in Vitamin D and Potassium',
        catchTechniques: ['Longlining', 'Set hooks', 'Bottom baiting'],
      ),
      FishSpecies(
        id: 'perch-1',
        commonName: 'Nile Perch',
        scientificName: 'Lates niloticus',
        description: 'A massive freshwater predator. While delicious, it is an invasive species in some areas but a major commercial fish in Africa.',
        habitats: ['Large lakes', 'Main river channels'],
        imageUrl: 'https://images.unsplash.com/photo-1611171830155-23912953327d?q=80&w=1000',
        howToCatch: 'Requires heavy tackle. Trolling with large lures or using live bait like smaller tilapia is effective.',
        isProtected: false,
        identificationTips: ['Huge size (up to 2m)', 'Silver color with a blue tinge', 'Distant yellow eyes', 'Distinctive spiked dorsal fin'],
        sizeLimits: '50cm minimum for sustainable catch',
        bestSeasons: ['Dry season', 'Early morning'],
        nutritionalValue: 'Very high in Protein and healthy fats',
        catchTechniques: ['Trolling', 'Heavy spinning', 'Live baiting'],
      ),
      FishSpecies(
        id: 'snapper-juvenile',
        commonName: 'Juvenile Snapper',
        scientificName: 'Lutjanus spp. (juvenile)',
        description: 'Young snappers under the legal size limit. These fish are critical to maintaining healthy populations and must be released immediately to ensure future stocks.',
        habitats: ['Shallow coastal waters', 'seagrass beds', 'mangroves'],
        imageUrl: 'assets/images/sign-up.png', // Brand background placeholder
        howToCatch: 'Avoid catching; if hooked, use circle hooks to minimize injury and release immediately.',
        isProtected: true,
        identificationTips: ['Similar to adults but smaller', 'May have different coloration patterns', 'Found in shallower nursery habitats', 'Often in schools'],
        sizeLimits: 'Under 25cm - MUST BE RELEASED',
        bestSeasons: ['N/A - Protected year-round'],
        nutritionalValue: 'N/A - Protected Species',
        catchTechniques: ['Catch and Release only'],
      ),
      FishSpecies(
        id: 'mackerel-restricted',
        commonName: 'Spanish Mackerel',
        scientificName: 'Scomberomorus commerson',
        description: 'While a popular commercial fish, Spanish Mackerel are currently under strict seasonal protection to prevent overfishing during spawning periods.',
        habitats: ['Open ocean', 'Coastal reefs', 'Outer shelf'],
        imageUrl: 'https://images.unsplash.com/photo-1514173255152-7e0b5f82bb57?q=80&w=1000',
        howToCatch: 'Currently restricted. If caught while targeting other species, handle with care and release without removing from water if possible.',
        isProtected: true,
        identificationTips: ['Elongated silver body', 'Numerous dark spots or bars', 'Sharp teeth', 'Deeply forked tail'],
        sizeLimits: 'RESTRICTED - Closed Season',
        bestSeasons: ['SEASON CLOSED'],
        nutritionalValue: 'N/A during restricted period',
        catchTechniques: ['N/A - Restricted'],
      ),
      FishSpecies(
        id: 'grouper-goliath',
        commonName: 'Goliath Grouper',
        scientificName: 'Epinephelus itajara',
        description: 'The Goliath Grouper is a critically endangered species. They can grow to massive sizes and are key to the health of reef ecosystems.',
        habitats: ['Coral reefs', 'Shipwrecks', 'Rocky ledges'],
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=1000',
        howToCatch: 'Strictly prohibited. Do not attempt to harvest. Taking a Goliath Grouper out of the water is illegal in many regions.',
        isProtected: true,
        identificationTips: ['Massive size and broad body', 'Small spots all over body', 'Rounded tail fin', 'Large mouth with thick lips'],
        sizeLimits: 'STRICTLY PROHIBITED',
        bestSeasons: ['N/A - Protected'],
        nutritionalValue: 'N/A - Illegal to Harvest',
        catchTechniques: ['DO NOT ATTEMPT TO CATCH'],
      ),
      FishSpecies(
        id: 'trout-brown',
        commonName: 'Brown Trout',
        scientificName: 'Salmo trutta',
        description: 'A highly prized game fish known for its wary nature and beautiful golden-brown color with red and black spots.',
        habitats: ['Clear streams', 'Cold rivers', 'Alpine lakes'],
        imageUrl: 'https://images.unsplash.com/photo-1590001158193-79017ae7a3e7?q=80&w=1000',
        howToCatch: 'Best caught with fly fishing gear or small spinners in clear, cold water.',
        isProtected: false,
        identificationTips: ['Golden body with spots', 'No spots on tail', 'Square-shaped tail', 'Red spots often have white halos'],
        sizeLimits: '20cm minimum',
        bestSeasons: ['Spring', 'Late Autumn'],
        nutritionalValue: 'Excellent source of Vitamin B12 and Omega-3',
        catchTechniques: ['Fly fishing', 'Spinning', 'Bait fishing'],
      ),
      FishSpecies(
        id: 'bass-black',
        commonName: 'Black Bass',
        scientificName: 'Micropterus salmoides',
        description: 'One of the most popular sport fish in the world, known for its aggressive strike and fighting ability.',
        habitats: ['Lakes', 'Slow-moving rivers', 'Vegetated areas'],
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=1000', // Replaced broken link with valid fish image
        howToCatch: 'Try using topwater lures, plastic worms, or jigs near structure like logs or lily pads.',
        isProtected: false,
        identificationTips: ['Large mouth reaching past eye', 'Deep notch in dorsal fin', 'Horizontal dark stripe on side', 'Greenish-black back'],
        sizeLimits: '30cm minimum',
        bestSeasons: ['Pre-spawn Spring', 'Summer mornings'],
        nutritionalValue: 'Lean meat, high in Selenium',
        catchTechniques: ['Casting', 'Trolling', 'Jigging'],
      ),
      FishSpecies(
        id: 'turtle-sea',
        commonName: 'Sea Turtle',
        scientificName: 'Cheloniidae family',
        description: 'All sea turtle species are highly protected. They are vital for marine biodiversity but face threats from habitat loss and poaching.',
        habitats: ['Open ocean', 'Sandy beaches (nesting)', 'Seagrass beds'],
        imageUrl: 'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?q=80&w=1000',
        howToCatch: 'DO NOT TARGET. If accidentally caught in nets, contact authorities and follow handled release protocols immediately.',
        isProtected: true,
        identificationTips: ['Large shell (carapace)', 'Flipper-like limbs', 'Cannot retract head into shell', 'Bird-like beak'],
        sizeLimits: 'TOTAL PROTECTION - ILLEGAL TO HARM',
        bestSeasons: ['N/A - Protected year-round'],
        nutritionalValue: 'N/A - Protected Species',
        catchTechniques: ['STRICTLY PROHIBITED'],
      ),
      FishSpecies(
        id: 'dugong-1',
        commonName: 'Dugong',
        scientificName: 'Dugong dugon',
        description: 'Often called "Sea Cows," dugongs are gentle herbivores. They are vulnerable to extinction and are strictly protected globally.',
        habitats: ['Shallow coastal waters', 'Seagrass meadows'],
        imageUrl: 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=1000',
        howToCatch: 'STRICTLY PROHIBITED. Highly endangered.',
        isProtected: true,
        identificationTips: ['Large torpedo-shaped body', 'Fluked tail like a whale', 'Down-turned snout', 'No dorsal fin'],
        sizeLimits: 'CRITICALLY ENDANGERED - PROTECTED',
        bestSeasons: ['N/A - Protected'],
        nutritionalValue: 'N/A - Protected Species',
        catchTechniques: ['ILLEGAL TO TARGET'],
      ),
      FishSpecies(
        id: 'shark-whale',
        commonName: 'Whale Shark',
        scientificName: 'Rhincodon typus',
        description: 'The largest known fish species. These gentle giants are filter feeders and are highly vulnerable to human activities.',
        habitats: ['Tropical oceans', 'Pelagic zones'],
        imageUrl: 'https://images.unsplash.com/photo-1560275619-4662e36fa65c?q=80&w=1000',
        howToCatch: 'PROTECTED. Swimming with them is regulated; harvesting is strictly illegal.',
        isProtected: true,
        identificationTips: ['White spots and stripes on dark back', 'Massive mouth at front of head', 'Broad flat head', 'Huge size'],
        sizeLimits: 'STRICTLY PROTECTED - ENDANGERED',
        bestSeasons: ['N/A - Protected'],
        nutritionalValue: 'N/A - Illegal to Harvest',
        catchTechniques: ['STRICTLY PROHIBITED'],
      ),
    ];

    try {
      final response = await _api.get('/fish/species');
      final List<dynamic> data = response.data['data'];
      final apiSpecies = data.map((json) => FishSpecies.fromJson(json)).toList();
      
      // Combine or prioritize mock data for now to meet user request
      return mockSpecies; 
    } catch (e) {
      return mockSpecies;
    }
  }

  Future<FishSpecies?> getSpeciesById(String id) async {
    try {
      final response = await _api.get('/fish/species/$id');
      return FishSpecies.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  }
}
