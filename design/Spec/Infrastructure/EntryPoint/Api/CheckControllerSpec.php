<?php

namespace Spec\App\Infrastructure\EntryPoint\Api;

use App\Infrastructure\EntryPoint\Api\CheckController;
use PhpSpec\ObjectBehavior;

/**
 * @mixin CheckController
 */
class CheckControllerSpec extends ObjectBehavior
{
    public function it_is_initializable(): void
    {
        $this->shouldHaveType(CheckController::class);
    }

    public function it_should_respond_with_OK(): void
    {
        $response = $this->__invoke();

        $response->getStatusCode()->shouldBe(200);
    }
}
