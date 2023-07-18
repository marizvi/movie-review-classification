import 'dart:math';

// 0: Very Bad - "A cinematic disaster that misses the mark."
// 1: Bad - "A disappointing film that fails to impress."
// 2: Average - "A passable movie with room for improvement."
// 3: Good - "A solid film that delivers an enjoyable experience."
// 4: Excellent - "A must-watch masterpiece that exceeds expectations."

int countWords(String input) {
  // Remove leading and trailing spaces
  input = input.trim();

  // If the string is empty, return 0
  if (input.isEmpty) {
    return 0;
  }

  // Split the string by spaces
  List<String> words = input.split(' ');

  // Filter out any empty strings
  words = words.where((word) => word.isNotEmpty).toList();

  // Return the count of remaining words
  return words.length;
}

String sentimentTile(int score) {
  Map<int, String> sentiment = {
    0: "A cinematic disaster that misses the mark.",
    1: "A disappointing film that fails to impress.",
    2: "A passable movie with room for improvement.",
    3: "A solid film that delivers an enjoyable experience.",
    4: "A must-watch masterpiece that exceeds expectations."
  };
  return sentiment[score] ?? "";
}

String getRandomCaption(int score) {
  // Define the map of captions associated with each score
  Map<int, List<String>> captions = {
    0: [
      "When life gives you lemons, and then steals your juicer too.",
      "Even the Titanic had better reviews.",
      "Time spent here is like watching paint dry... in slow motion."
          "Sometimes even the stars can't save a movie",
    ],
    1: [
      "Find solace in the fact that bad reviews make great stories.",
      "This experience will make you appreciate all the other mediocre things in life.",
      "A roller coaster ride without the fun. Just the nausea."
    ],
    2: [
      "A lukewarm experience that won't rock your world but won't ruin it either.",
      "The beige of reviews: neither here nor there.",
      "Forgettable, but hey, at least it wasn't terrible."
    ],
    3: [
      "A delightful surprise in a world of disappointments.",
      "Smiles guaranteed, refunds not necessary.",
      "Leaving you with a warm and fuzzy feeling."
    ],
    4: [
      "Prepare for a review-worthy experience that'll make your friends jealous.",
      "An absolute gem in a sea of mediocrity.",
      "Hold on tight, this is a 5-star adventure!"
    ]
  };

  // Check if the score is within the valid range
  if (captions.containsKey(score)) {
    // Get the list of strings associated with the given score
    List<String> scoreCaptions = captions[score] ?? [];

    // Generate a random index within the range of the list
    int randomIndex = Random().nextInt(scoreCaptions.length);

    // Return a random string from the list
    return scoreCaptions[randomIndex];
  } else {
    // Invalid score, return an empty string or handle the error as desired
    return "";
  }
}
