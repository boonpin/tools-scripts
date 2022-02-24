<?php

// function for async lock in php
// not a best solution, but at least better than non-lock
function flock_run($file, $timeout, $run)
{
    $fs = fopen($file, "w+");

    try {
        $start = time();

        if (flock($fs, LOCK_EX | LOCK_NB)) {
            $run();
            flock($fs, LOCK_UN);
        } else {
            // wait for release
            while (!flock($fs, LOCK_EX | LOCK_NB, $wouldblock)) {
                $duration = time() - $start;
                if ($wouldblock && $duration < $timeout) {
                    sleep(1);
                } else {
                    throw new RuntimeException("timeout on lock $file");
                }
            }
        }
    } finally {
        if ($fs) {
            fclose($fs);
        }
    }
}

// example to use
// lock on /tmp/test.lock, 10 seconds timeout
$count = 1;
flock_run("/tmp/test.lock", 10, function () use (&$count) {
    while (true) {
        echo date('Y-m-d H:i:s') . ": hello world1 $count\n";
        $count++;
        sleep(2);
    }
});
