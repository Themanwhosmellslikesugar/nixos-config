{ ... }:

let
  selectedModel = "openrouter/minimax-m2.7";

  modelSet = { model = selectedModel; };
in
{
  xdg.configFile."opencode/oh-my-opencode.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json";

    agents = {
      hephaestus = modelSet;
      oracle = modelSet;
      librarian = modelSet;
      explore = modelSet;
      multimodal-looker = modelSet;
      prometheus = modelSet;
      metis = modelSet;
      momus = modelSet;
      atlas = modelSet;
      sisyphus-junior = modelSet;
    };

    categories = {
      visual-engineering = modelSet;
      ultrabrain = modelSet;
      deep = modelSet;
      artistry = modelSet;
      quick = modelSet;
      unspecified-low = modelSet;
      unspecified-high = modelSet;
      writing = modelSet;
    };
  };
}
