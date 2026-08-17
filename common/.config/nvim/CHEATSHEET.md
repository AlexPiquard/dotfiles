# vim


| mode                   | keymap |
|------------------------|--------|
| \[v\]isual (selection) | v      |
| insert \[a\]fter       | a      |
| insert before          | i      |
| replace                | r      |


| operator          | keymap |
|-------------------|--------|
| delete            | d      |
| delete and insert | c      |
| copy              | y      |
| paste             | p      |


| motion                    | keymap |
|---------------------------|--------|
| move to start of line     | 0      |
| move \[e\]nd of word      | e      |
| move next \[w\]ord        | w      |
| move start of word        | b      |
| move end of previous word | ge     |
| move to end of line       | $      |


| action                     | keymap   |
|----------------------------|----------|
| cut word                   | diw      |
| cut word and space after   | daw      |
| new line after             | o        |
| new line before            | O        |
| move cursor half page      | ctrl u/d |
| move screen                | ctrl y/e |
| move previous position     | ctrl o   |
| move back                  | ctrl i   |
| close part of code (fold)  | zc       |
| create vertical split      | ctrl-w v |
| create horizontal split    | ctrl-w s |
| new tab                    | alt n    |
| close tab                  | alt k    |
| previous tab               | alt ,    |
| next tab                   | alt ;    |
| empty line and insert mode | S        |
| empty at right             | D        |
| empty at right and insert  | C        |
| insert at end              | A        |
| insert at beginning        | I        |


| plugin action               | keymap      |
|-----------------------------|-------------|
| next/previous error         | alt b/B     |
| open color picker           | ctrl p      |
| toggle table mode in readme | <leader>tm  |
| todos picker                | <leader>st  |
| files picker                | <leader>ff  |
| previous picker             | <leader>fr  |
| grep picker                 | <leader>fw  |
| buffers picker              | <leader>,   |
| diagnostics picker          | <leader>sd  |
| diagnostics in buffer       | <leader>sD  |
| buffer structure            | <leader>ft  |
| references picker           | gr          |
| goto definition             | gd
| go to type definition       | <leader>T   |
| search and replace          | <leader>sr  |
| rename variable             | grn         |
| add workspace folder (lsp)  | <leader>wa  |
| remove workspace folder     | <leader>wa  |
| list code actions           | <leader>ca  |
| list sessions               | <leader>ws  |
| delete session              | <leader>wd  |
| lazygit                     | <leader>lg  |
| git log file                | <leader>gf  |
| git log                     | <leader>gl  |
| git log line                | <leader>gL  |
| git diff                    | <leader>gd  |
| git reset hunk              | <leader>hr  |
| git reset buffer            | <leader>hR  |
| git preview hunk            | <leader>hp  |
| git blame                   | <leader>hb  |
| bookmarks (arrow)           | q           |
| buffer bookmarks (arrow)    | m           |
| debugger                    | <leader>d   |
| move selection              | alt h/j/k/l |


# TODO

- fix markdown paragraphs
- something detecting malicious/dangerous code when opening project (eval, etc)
- something in tmux to load a predefined setup in a tab (multiple windows and cmd in each)
- https://github.com/DNLHC/glance.nvim / https://github.com/rmagatti/goto-preview (reference preview not working) / https://nvimdev.github.io/
- speed up blink in rust
- make gd opens the already visible buffer (even in other tab) (not working for tabs)
- symlinked subfolders with stow
- todo-comments errors without the ending ":"
- disable highlight for color words in comments
- https://github.com/kosayoda/nvim-lightbulb ? to see available actions
- https://github.com/rachartier/tiny-code-action.nvim : better way to see actions ? 
- https://github.com/icholy/lsplinks.nvim (https://github.com/davidosomething/dotfiles/blob/dev/nvim/lua/dko/plugins/lsp.lua)
- change keymap to accept terminal suggestion (instead of arrow)
