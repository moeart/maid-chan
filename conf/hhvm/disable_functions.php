<?php

function __forbidden_function($name, $obj, $args, $data, &$done) {
  throw new Exception('Maid-Chan: Function '.$name.' is disabled.');
}

fb_intercept('pcntl_alarm', '__forbidden_function');
fb_intercept('pcntl_fork', '__forbidden_function');
fb_intercept('pcntl_waitpid', '__forbidden_function');
fb_intercept('pcntl_wait', '__forbidden_function');
fb_intercept('pcntl_wifexited', '__forbidden_function');
fb_intercept('pcntl_wifstopped', '__forbidden_function');
fb_intercept('pcntl_wifsignaled', '__forbidden_function');
fb_intercept('pcntl_wexitstatus', '__forbidden_function');
fb_intercept('pcntl_wtermsig', '__forbidden_function');
fb_intercept('pcntl_wstopsig', '__forbidden_function');
fb_intercept('pcntl_signal', '__forbidden_function');
fb_intercept('pcntl_signal_dispatch', '__forbidden_function');
fb_intercept('pcntl_get_last_error', '__forbidden_function');
fb_intercept('pcntl_strerror', '__forbidden_function');
fb_intercept('pcntl_sigprocmask', '__forbidden_function');
fb_intercept('pcntl_sigwaitinfo', '__forbidden_function');
fb_intercept('pcntl_sigtimedwait', '__forbidden_function');
fb_intercept('pcntl_exec', '__forbidden_function');
fb_intercept('pcntl_getpriority', '__forbidden_function');
fb_intercept('pcntl_setpriority', '__forbidden_function');
fb_intercept('phpinfo', '__forbidden_function');
fb_intercept('eval', '__forbidden_function');
fb_intercept('passthru', '__forbidden_function');
fb_intercept('exec', '__forbidden_function');
fb_intercept('system', '__forbidden_function');
fb_intercept('chroot', '__forbidden_function');
fb_intercept('scandir', '__forbidden_function');
fb_intercept('chgrp', '__forbidden_function');
fb_intercept('chown', '__forbidden_function');
fb_intercept('shell_exec', '__forbidden_function');
fb_intercept('proc_open', '__forbidden_function');
fb_intercept('proc_get_status', '__forbidden_function');
fb_intercept('ini_alter', '__forbidden_function');
fb_intercept('ini_restore', '__forbidden_function');
fb_intercept('dl', '__forbidden_function');
fb_intercept('pfsockopen', '__forbidden_function');
fb_intercept('openlog', '__forbidden_function');
fb_intercept('syslog', '__forbidden_function');
fb_intercept('readlink', '__forbidden_function');
fb_intercept('symlink', '__forbidden_function');
fb_intercept('popepassthru', '__forbidden_function');
fb_intercept('stream_socket_server', '__forbidden_function');
fb_intercept('fsocket', '__forbidden_function');
fb_intercept('fsockopen', '__forbidden_function');
