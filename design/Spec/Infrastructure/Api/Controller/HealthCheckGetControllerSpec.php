<?php

namespace Design\App\Spec\Infrastructure\Api\Controller;

use App\Infrastructure\Api\Controller\HealthCheckGetController;
use PhpSpec\ObjectBehavior;

/**
 * @mixin HealthCheckGetController
 */
class HealthCheckGetControllerSpec extends ObjectBehavior
{
    public function it_is_initializable(): void
    {
        $this->shouldHaveType(HealthCheckGetController::class);
    }

    public function it_should_respond_with_OK(): void
    {
        $response = $this->__invoke();

        $response->getStatusCode()->shouldBe(200);
    }
}
