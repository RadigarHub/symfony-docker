<?php

declare(strict_types=1);

namespace App\Infrastructure\Api\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

final class HealthCheckGetController extends AbstractController
{
    public function __invoke(Request $request): JsonResponse
    {
        return new JsonResponse(['message' => 'OK']);
    }
}
