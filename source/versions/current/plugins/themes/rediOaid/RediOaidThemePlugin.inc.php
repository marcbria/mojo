<?php

/**
 * @file RediOaidThemePlugin.inc.php
 *
 * Copyright (c) 2003-2011 Marc Bria - ReDi - OAID - UAB
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class RediOaidThemePlugin
 * @ingroup plugins_themes_rediOaid
 *
 * @brief "RediOaid" theme plugin
 */

// $Id$


import('classes.plugins.ThemePlugin');

class RediOaidThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'RediOaidThemePlugin';
	}

	function getDisplayName() {
		return 'RediOaid Theme';
	}

	function getDescription() {
		return 'ReDi-OAID layout';
	}

	function getStylesheetFilename() {
		return 'rediOaid.css';
	}

	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
