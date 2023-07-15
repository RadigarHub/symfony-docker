<?php

declare(strict_types=1);

namespace App\Infrastructure\EntryPoint\Api;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class CheckController
{
    #[Route('/api/check', name: 'api_check', methods: ['GET'])]
    public function __invoke(): Response
    {
        return new JsonResponse(['message' => 'OK'], Response::HTTP_OK);
    }
}
