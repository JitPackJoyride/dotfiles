{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.vim-tmux-navigator
    ];
    settings = {
      number = true;
      relativenumber = true;
      copyindent = true;
    };
    extraConfig = ''
      set autoindent
      set nocompatible
      filetype off
      filetype plugin indent on
      syntax on
      set shell=/bin/bash
    '';
  };
}
