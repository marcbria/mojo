<?php

/**
 * @file tools/bootstrap.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup tools
 *
 * @brief application-specific configuration common to all tools (corresponds
 *  to index.php for web requests).
 */

// $Id$


//MBR: http://pkp.sfu.ca/support/forum/viewtopic.php?f=8&t=7578&p=32525#p32525
// define('INDEX_FILE_LOCATION', dirname(dirname(__FILE__)) . '/index.php');
define('INDEX_FILE_LOCATION', realpath(dirname(dirname($_SERVER["SCRIPT_FILENAME"]))). '/index.php');
require(dirname(dirname(__FILE__)) . '/lib/pkp/classes/cliTool/CliTool.inc.php');
?>
