-- Näytetään pystyviiva 80 merkin kohdalla (visuaalinen ohje)
vim.opt_local.colorcolumn = "80"

-- Jos haluat, että Neovim katkaisee rivin automaattisesti (hard wrap)
-- kun saavutat 80 merkkiä:
vim.opt_local.textwidth = 80

-- Rivitys päälle (soft wrap), jotta teksti ei mene piiloon oikealle
vim.opt_local.wrap = true

-- Lisävinkki: Aktivoi oikeinkirjoituksen tarkistus (suomi/englanti)
vim.opt_local.spell = true
