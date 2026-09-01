#!/usr/bin/env bash
# Sciagawka skrotow tmuxa - wyswietlana w popupie pod C-a ?
# Zrodlo prawdy to ~/code/dotfiles/tmux.conf; ten plik trzeba aktualizowac recznie.

T=$'\033[1;38;5;223m'   # tytul
H=$'\033[1;38;5;183m'   # naglowek sekcji
K=$'\033[38;5;111m'     # klawisz
D=$'\033[38;5;189m'     # opis
M=$'\033[38;5;244m'     # przygaszone
R=$'\033[0m'

sec() { printf '\n%s%s%s\n' "$H" "$1" "$R"; }
row() { printf '  %s%-14s%s %s%s%s\n' "$K" "$1" "$R" "$D" "$2" "$R"; }
note() { printf '  %s%s%s\n' "$M" "$1" "$R"; }

render() {
  printf '%s  tmux - sciagawka%s   %sprefix = C-a%s\n' "$T" "$R" "$M" "$R"

  sec 'PANELE'
  row 'C-a |'       'split pionowy (obok siebie), w katalogu panelu'
  row 'C-a -'       'split poziomy (jeden pod drugim)'
  row 'C-h C-j C-k C-l' 'ruch miedzy panelami - BEZ prefiksu'
  note 'w vimie/nvimie te same klawisze ida do vima, nie do tmuxa'
  row 'C-a H J K L' 'zmiana rozmiaru o 5 (mozna przytrzymac)'
  row 'C-a z'       'zoom panelu na cale okno (lub dwuklik w krawedz)'
  row 'C-a q'       'pokaz numery paneli - 2 s na wybor'
  row 'C-a T'       'ustaw wlasny tytul panelu'
  row 'C-a b'       'oderwij panel do osobnego okna (w tle)'
  row 'C-a @'       'wciagnij inne okno jako panel obok'
  row 'C-a x'       'zamknij panel'

  sec 'OKNA'
  row 'C-a c'       'nowe okno w katalogu biezacego panelu'
  row 'C-a 1 .. 9'  'skok do okna o numerze'
  row 'C-a n / p'   'nastepne / poprzednie okno'
  row 'C-a ,'       'zmien nazwe okna'
  row 'C-a < / >'   'przesun okno w lewo / w prawo'
  row 'C-a &'       'zamknij okno'

  sec 'UKLADY PANELI'
  row 'C-a M-1'     'wszystkie panele w rzedzie (even-horizontal)'
  row 'C-a M-2'     'wszystkie panele w kolumnie (even-vertical)'
  row 'C-a M-3'     'jeden duzy u gory, reszta pod spodem'
  row 'C-a M-4'     'jeden duzy z lewej, reszta z prawej'
  row 'C-a M-5'     'kafelki (tiled)'
  row 'C-a spacja'  'nastepny uklad z listy'
  row 'C-a M-o'     'obroc panele w miejscach'

  sec 'SESJE'
  row 'C-a o'       'przelacznik sesji - sesh + fzf'
  row 'C-a O'       'tp - sesja projektu: Agenci / IDE / Terminal'
  row 'C-a s'       'drzewo sesji i okien'
  row 'C-a ^'       'wroc do poprzedniej sesji'
  row 'C-a d'       'odlacz sie od sesji (dziala dalej w tle)'
  row 'M-p'         'scratch w popupie - BEZ prefiksu'

  sec 'POPUPY'
  row 'C-a g'       'lazygit w katalogu biezacego panelu'
  row 'C-a ?'       'ta sciagawka'
  row 'C-a /'       'pelna, surowa lista bindingow tmuxa'

  sec 'KOPIOWANIE  (tryb vi)'
  row 'C-a ['       'wejdz w tryb kopiowania'
  row 'v'           'zacznij zaznaczac'
  row 'y'           'kopiuj do schowka Windows (clip.exe) i wyjdz'
  row '/  ?'        'szukaj w przod / w tyl'
  row 'q'           'wyjdz z trybu kopiowania'
  note 'zaznaczenie myszka kopiuje od razu, bez wchodzenia w tryb'

  sec 'INNE'
  row 'C-a r'       'przeladuj ~/.tmux.conf'
  row 'C-a C-a'     'wyslij prawdziwe C-a do programu w panelu'
  note 'status bar: ⛶ = panel zzoomowany, ● = dzwonek w tle'

  printf '\n%s  q - zamknij   |   strzalki / PgUp / PgDn - przewijanie%s\n' "$M" "$R"
}

render | less -R
