<?php

use CodelyTv\CodingStyle;
use Symplify\EasyCodingStandard\Config\ECSConfig;
use Symplify\EasyCodingStandard\ValueObject\Option;

return function (ECSConfig $ecsConfig): void {
    $ecsConfig->paths([__DIR__ . '/src',]);
    $ecsConfig->paths([__DIR__ . '/tests',]);

    $ecsConfig->sets([CodingStyle::DEFAULT]);

    // Or this if you prefer to have the code aligned
    // $ecsConfig->sets([CodingStyle::ALIGNED]);

    $ecsConfig->indentation(Option::INDENTATION_SPACES);
};
