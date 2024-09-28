import pygame
import random
import math

pygame.init()

# поле
width, height = 800, 600
screen = pygame.display.set_mode((width, height))
clock = pygame.time.Clock()


white = (255, 255, 255)
black = (0, 0, 0)
red = (255, 0, 0)


ball_radius = 10
ball_pos = [random.randint(ball_radius, width - ball_radius),
            random.randint(ball_radius + 50, height - ball_radius)]  # щоб не попасти у вершину одразу


angle = random.uniform(0, 2 * math.pi)
ball_speed = 4.9


ball_velocity = [ball_speed * math.cos(angle), ball_speed * -ball_speed * math.sin(angle)]
collision_count = 0
is_moving = True

# вершина
peak_width = 70
peak_height = 70
peak_x = random.randint(0, width - peak_width)
peak_y = random.randint(0, height - peak_height)
peak_pos = (peak_x, peak_y)

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    if is_moving:
        ball_pos[0] += ball_velocity[0]
        ball_pos[1] += ball_velocity[1]

        # право ліво
        if ball_pos[0] <= ball_radius or ball_pos[0] >= width - ball_radius:
            ball_velocity[0] = -ball_velocity[0]
            collision_count += 1

        # верх
        if ball_pos[1] <= ball_radius:
            ball_velocity[1] = -ball_velocity[1]
            collision_count += 1

        # вершина
        if (peak_pos[0] <= ball_pos[0] <= peak_pos[0] + peak_width and
                peak_pos[1] <= ball_pos[1] <= peak_pos[1] + peak_height):
            is_moving = False

        # низ
        elif ball_pos[1] >= height - ball_radius:
            ball_velocity[1] = -ball_velocity[1]
            collision_count += 1

    screen.fill(white)

    pygame.draw.circle(screen, black, (int(ball_pos[0]), int(ball_pos[1])), ball_radius)

    pygame.draw.rect(screen, red, (
        peak_pos[0], peak_pos[1], peak_width, peak_height))

    font = pygame.font.Font(None, 36)
    text = font.render(f'Number of collisions: {collision_count}', True, black)
    screen.blit(text, (10, height - 40))

    pygame.display.flip()
    clock.tick(60)

pygame.quit()
