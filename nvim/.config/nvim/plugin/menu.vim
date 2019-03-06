
" Add custom menus
let s:menus = {}

let s:menus.zsh = {
            \ 'description': 'Edit your import zsh configuration'
            \ }
let s:menus.zsh.file_candidates = [
            \ ['zshrc', '~/.config/zsh/.zshrc'],
            \ ['zshenv', '~/.zshenv'],
            \ ]

let s:menus.my_commands = {
            \ 'description': 'Example commands'
            \ }
let s:menus.my_commands.command_candidates = [
            \ ['Split the window', 'vnew'],
            \ ['Open zsh menu', 'Denite menu:zsh'],
            \ ['Format code', 'FormatCode', 'go,python'],
            \ ]

" call denite#custom#var('menu', 'menus', s:menus)
