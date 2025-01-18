<?php

declare(strict_types=1);

namespace App\Infrastructure\Api\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;

final class HealthCheckGetController extends AbstractController
{
    public function __invoke(): JsonResponse
    {
        return new JsonResponse(['message' => 'OK']);
    }
}
