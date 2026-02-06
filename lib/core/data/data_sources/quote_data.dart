class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});
}

class QuoteData {
  static const List<Quote> quotes = [
    Quote(
      text:
          "If you want to reach the top, you have to work your way up from the bottom.",
      author: "SAITAMA",
    ),
    Quote(
      text:
          "Human strength is about the ability to change yourself by yourself.",
      author: "SAITAMA",
    ),
    Quote(
      text:
          "Propelled by the power of his will, he went through the hellish training.",
      author: "GENOS",
    ),
    Quote(
      text:
          "The only way to become strong is to train until you think you're going to die.",
      author: "SAITAMA",
    ),
    Quote(
      text:
          "Power is not determined by your size, but by the size of your heart and dreams.",
      author: "MONKEY D. LUFFY",
    ),
    Quote(
      text:
          "Hard work is worthless for those that don't believe in themselves.",
      author: "NARUTO UZUMAKI",
    ),
    Quote(
      text: "A person who cannot sacrifice anything, can change nothing.",
      author: "ARMIN ARLERT",
    ),
    Quote(
      text: "It's not about whether you can or can't. You just do it.",
      author: "SAITAMA",
    ),
    Quote(
      text:
          "You can't sit around and wait for a miracle. You have to make it happen.",
      author: "MUMEN RIDER",
    ),
    Quote(
      text:
          "Do not seek to follow in the footsteps of the men of old; seek what they sought.",
      author: "MATSUO BASHO",
    ),
  ];

  static Quote getQuoteForDay(int day) {
    // Simple rotation logic for now
    return quotes[day % quotes.length];
  }
}
