defmodule Wankrank.NameGenerator do
  @adjectives ~w(
    Big Small Large Massive Gargantuan Tiny Miniscule Minute Wide Tall Short
    Slim Adorable Beautiful Clean Drab Elegant Fancy Glamorous Handsome Long
    Magnificent Old-fashioned Plain Quaint Sparkling Ugliest Unsightly
    Wide-eyed Angry Bewildered Clumsy Defeated Embarrassed
    Fierce Grumpy Helpless Itchy Jealous Lazy Mysterious
    Nervous Obnoxious Panicky Repulsive Scary Thoughtless
    Uptight Worried Bitter Delicious Fresh Greasy Juicy Hot Icy
    Loose Melted Nutritious Prickly Rainy Rotten Salty Sticky
    Strong Sweet Tart Tasteless Uneven Weak Wet Wooden Yummy
    Agreeable Brave Calm Delightful Eager Faithful Gentle Happy
    Jolly Kind Lively Nice Obedient Proud Relieved Silly
    Thankful Victorious Witty Zealous Ancient Brief Early Fast
    Late Modern Old Quick Rapid Short Slow Swift Young Broad
    Chubby Crooked Curved Deep Flat High Hollow Low Narrow Round
    Shallow Skinny Square Steep Straight Wide
  )
  @attributes ~w(
    Strong Wild Fierce Crazy Insane Mad Horrific Terrible Greedy Lustful
    Rabid Blasphemous Adaptable Adventurous Affable Affectionate Agreeable
    Ambitious Amiable Amicable Amusing Brave Bright Broad-minded Calm Careful
    Charming Communicative Compassionate Conscientious Considerate
    Convivial Courageous Courteous Creative Decisive Determined
    Diligent Diplomatic Discreet Dynamic Easygoing Emotional
    Energetic Enthusiastic Exuberant Fair-minded Faithful Fearless
    Forceful Frank Friendly Funny Generous Gentle Good Gregarious
    Hard-working Helpful Honest Humorous Imaginative Impartial
    Independent Intellectual Intelligent Intuitive Inventive Kind
    Loving Loyal Modest Neat Nice Optimistic Passionate Patient
    Persistent  Pioneering Philosophical Placid Plucky Polite
    Powerful Practical Pro-active Quick-witted Quiet Rational
    Reliable Reserved Resourceful Romantic Self-confident Self-disciplined
    Sensible Sensitive Shy Sincere Sociable Straightforward
    Sympathetic Thoughtful Tidy Tough Unassuming Understanding
    Versatile Warmhearted Willing Witty
    Aggressive Aloof Arrogant Belligerent Big-headed Bitchy Boastful
    Bone-idle Boring Bossy Callous Cantankerous Careless Changeable
    Clinging Compulsive Conservative Cowardly Cruel Cunning Cynical
    Deceitful Detached Dishonest Dogmatic Domineering Finicky
    Flirtatious Foolish Foolhardy Fussy Greedy Grumpy Gullible
    Harsh  Impatient Impolite Impulsive Inconsiderate Inconsistent
    Indecisive Indiscreet Inflexible Interfering Intolerant
    Irresponsible Jealous Lazy Materialistic Mean Miserly Moody
    Narrow-minded Nasty Naughty Nervous Obsessive Obstinate
    Overcritical Overemotional Parsimonious Patronizing Perverse
    Pessimistic Pompous Possessive Pusillanimous Quarrelsome
    Quick-tempered Resentful Rude Ruthless Sarcastic Secretive
    Selfish Self-centred Self-indulgent Silly Sneaky Stingy
    Stubborn Stupid Superficial Tactless Timid Touchy Thoughtless
    Truculent Unkind Unpredictable Unreliable Untidy Untrustworthy
    Vague Vain Vengeful Vulgar Weak-willed
  )
  @nouns ~w(
    Aardvark Armadillo Baboon Beaver Bear Bobcat Caribou Cheetah Chimpanzee
    Chipmunk Cougar Coyote Dingo Dugong Elephant Elk Fox Gibbon Giraffe
    Groundhog Hedgehog Hippopotamus Horse Impala Jackrabbit Jaguar Koala
    Leopard Lion Llama Lynx Manatee Mandrill Meerkat Mangoose Moose Narwhal
    Opossum Orangutan Orca Platypus Porcupine Raccoon Skunk Sloth Squirrel
    Tapir Wallaby Walrus Warthog Wildebeest Wolf Wolverine Zebra
    Adder Alligator Anaconda Basilisk Boa Chameleon Cobra Copperhead Crocodile
    Gecko Iguana Komodo Lizard Mamba Python Rattlesnake Taipan Tortoise
    Tuatara Turtle Viper Whipsnake Harlequin Lyre Montpellier
    Frog Toad Caecilian Salamander Newt Axolotl
    Ant Aphid Bedbug Bee Beetle Black-widow Bloodsucker Boll-weevil Bumblebee
    Blowfly Butterfly Caterpillar Centipede Cicada Cockroach Cricket Dragonfly
    Earthworm Firefly Flea Fly Glow-worm Grasshopper Honeybee Horsefly
    Ladybird Ladybug Leech Lice Locust Maggot Mantis Mayfly Millipede
    Mosquito Moth Queen Roach Scarab Silkworm Slug Snail Spider Tarantula
    Termite Tick Wasp
    Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey Rooster Dog Pig
  )
  def generate_username do
    # Seed :random so it's a bit more random than usual
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    name = [@adjectives, @attributes, @nouns]
    |> Enum.map(fn word_list -> Enum.random(word_list) end)
    |> Enum.join("")
  end
end

