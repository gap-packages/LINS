\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}
\ProvidesClass{bachelorarbeit}

\RequirePackage{underscore}
\RequirePackage{longtable}
\RequirePackage{tikz}
\usetikzlibrary{babel}
\RequirePackage{tikz-cd}
\tikzcdset{arrow style=tikz, diagrams={>=stealth}}

\RequirePackage{mathtools}
\RequirePackage{amsmath, amsfonts, amssymb}

\RequirePackage{ifluatex}
\ifluatex
    \RequirePackage[babelshorthands]{polyglossia}
    \setdefaultlanguage[spelling=new]{german}
    \RequirePackage[warnings-off={mathtools-colon,mathtools-overbracket}]{unicode-math}
    \setromanfont{TeX Gyre Pagella}
    \setsansfont{Latin Modern Sans}
    \setmathfont{TeX Gyre Pagella Math}
    \setmathfont[range=\setminus]{XITS Math}
    \setmathfont[range=\mathbb]{TeX Gyre Termes Math}
\else
    %\RequirePackage[ngerman]{babel}
    \RequirePackage[utf8]{inputenc}
\fi 

\RequirePackage{csquotes}

\setkomafont{disposition}{\bfseries}
\setkomafont{descriptionlabel}{\bfseries}
\RequirePackage{setspace}
\setstretch{1.08}
% \setlength\parskip{4pt}
% \setlength\parindent{0pt}

\RequirePackage[amsmath, thmmarks, framed]{ntheorem}
\RequirePackage[framemethod=tikz]{mdframed}

\RequirePackage{hyperref}
\RequirePackage[capitalise, nameinlink]{cleveref}
\RequirePackage{versions}

\hypersetup{
    colorlinks = true,
    linkbordercolor = {white},
    linkcolor = {cyan}
}

\makeatletter
\def\@ythm#1#2#3[#4]{\def\@currentlabelname{#4}%
  \expandafter\global\expandafter\def\csname#1name\endcsname{#4}%
  \@opargbegintheorem{#3}{\csname the#2\endcsname}{#4}%
  \ifx\thm@starredenv\@undefined
    \thm@thmcaption{#1}{{#3}{\csname the#2\endcsname}{#4}}\fi
  \ignorespaces}
\DeclareRobustCommand{\nameref}[1]{\nameref{#1}\ \ref{#1}}
\makeatother

\RequirePackage{scrpage2}
\RequirePackage{authoraftertitle}


\pagestyle{plain}

\newcounter{thmcount}
\numberwithin{thmcount}{section}
% \numberwithin{thmcount}{section}
% \def\newthm#1#2{\newtheorem{#1}[thmcount]{#2}}
\def\newthm#1#2{\newmdtheoremenv[ntheorem,
    linewidth=5pt,
    linecolor=black!20,
    leftline=true, rightline=false, bottomline=false, topline=false,
    innerleftmargin=1em,
    leftmargin=1em,
    ]{#1}[thmcount]{#2}}
\def\newdef#1#2{\newtheorem{#1}[thmcount]{#2}}

% Kursive Schrift
\theoremstyle{plain}
\theoremseparator{.}
\newthm{thm}{Theorem}
\newthm{lem}{Lemma}
\newthm{cor}{Corollary}

% Aufrechte Schrift
\theorembodyfont{\normalfont}
\newdef{defi}{Definition}
\newdef{examp}{Example}

\renewcommand{\beginmarkversion}{
    \begin{mdframed}[
        backgroundcolor=green!20]}
\renewcommand{\endmarkversion}{\end{mdframed}}

% \let\emph\relax
% \DeclareTextFontCommand{\emph}{\bfseries}

\theoremstyle{nonumberplain}
\theoremheaderfont{\itshape}
\theorembodyfont{\normalfont}
\theoremseparator{.}
% \theoremsymbol{\scalebox{0.8}{\ensuremath{\blacksquare}}}
\theoremsymbol{\nolinebreak[1]\hspace*{.5em plus 1fill}\ensuremath{\Box}}

\newtheorem{proof}{Proof}

\endinput
