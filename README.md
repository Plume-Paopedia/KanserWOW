# Midnight Macro Forge

**Midnight Macro Forge** est un addon World of Warcraft Retail (prépatch Midnight) orienté **création de macros guidée** avec une interface moderne, un système de templates par classe/spé, et des options avancées de génération.

## Objectif

Offrir un workflow simple et premium pour créer des macros utiles sans devoir écrire tout le code macro manuellement.

## Fonctionnalités

- Interface complète avec panneau principal (style dark, UX orientée productivité)
- Sélection de classe, filtre par rôle, mode de ciblage
- Recherche dynamique de templates
- Templates par classe/spé (Retail)
- Favoris de templates
- Builder rapide via snippets réutilisables
- Prévisualisation éditable avant création
- Création **ou** mise à jour automatique de macro existante
- Vérification des limites Blizzard (nom, longueur, slots compte/personnage)
- Persistance des préférences utilisateur (SavedVariables)

## Commandes

- `/mmf` : ouvrir/fermer l'interface
- `/midmacro` : alias de `/mmf`
- `/mmf help` : afficher l'aide
- `/mmf reset` : réinitialiser le profil addon
- `/mmf favorites` : afficher le nombre de templates favoris

## Installation

1. Copier le dossier `MidnightMacroForge` dans :
   - Windows: `_retail_/Interface/AddOns/`
2. Lancer le jeu et activer l’addon dans la liste des addons.
3. En jeu, taper `/mmf`.

## Structure du projet

- `MidnightMacroForge/MidnightMacroForge.toc`
- `MidnightMacroForge/Core.lua`
- `MidnightMacroForge/Data.lua`
- `MidnightMacroForge/Generator.lua`
- `MidnightMacroForge/UI.lua`

## Compatibilité

- Retail
- Interface TOC: `120000`

## Limites connues

- Les macros WoW restent soumises aux restrictions natives Blizzard (taille et API sécurisée).
- Les templates fournis sont des bases robustes mais peuvent nécessiter un ajustement selon les patchs d’équilibrage.

## Roadmap (prochaine itération)

- Import/export de presets utilisateurs
- Détection automatique plus fine des specs actives et contextes (PvE/PvP)
- Plus de snippets spécialisés (arena focus, mouseover heal avancé, ground macros contextualisées)
- Outils de diagnostic UX (ex: avertissement automatique si macro proche de la limite 255)

## Licence

Projet privé KanserWOW (ajuster selon votre politique de distribution).
