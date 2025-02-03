<template>
  <v-container>
    <v-row class="text-center">
      <v-col cols="12">
      </v-col>

      <v-col class="mb-4">
        <!-- <p class="text-h2">Takatomo Inoue Project</p> -->
        <p class="text-h2">Arabic Alchemical Literature Digital Edition by Takatomo Inoue</p>
        <p class="heading font-weight-regular">
          Editing and Translating Manuscripts on Alchemy in Medieval Islam
          <br/>
          Using TEI P5 Encording
        </p>
      </v-col>

      <v-col
        class="mb-5"
        cols="12"
      >
        <h2 class="headline font-weight-bold mb-10">
          Contents
        </h2>

        <v-row justify="center">
          <!-- <a
            v-for="(next, i) in whatsNext"
            :key="i"
            :href="next.href"
            class="subheading mx-3"
            target="_blank"
          >
            {{ next.text }}
          </a> -->
          <v-card
            v-for="(next, i) in contents"
            :key="i"
            class="subheading mx-3"
          >
            <v-card-title class="fill-height align-center">
              <router-link
                :to="next.href"
                class="subheading mx-3 "
              >
                <div style="white-space: pre;">{{ next.text }}</div>
              </router-link>
            </v-card-title>
          </v-card>
        </v-row>
      </v-col>

      <v-col
        class="mb-5"
        cols="12"
      >
        <h2 class="headline font-weight-bold my-10">
          Important Links
        </h2>

        <v-row justify="center">
          <v-card
            v-for="(next, i) in links"
            :key="i"
            class="subheading mx-3"
          >
            <v-card-title>
              <a
                :href="next.href"
                class="subheading mx-3"
                target="_blank"
              >
              <div style="white-space: pre;">{{ next.text }}</div>
              </a>
            </v-card-title>
          </v-card>
        </v-row>
      </v-col>

    </v-row>
  </v-container>
</template>

<script>
  export default {
    name: 'Home',

    data: () => ({
      links: [
        {
          text: 'TEI',
          href: 'https://tei-c.org',
        },
        {
          text: 'P5 Guideline',
          href: 'https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html',
        },
      ],
      contents: [
        {
          text: 'About',
          href: '/about',
        },
        {
          text: 'Edition',
          href: '/edition',
        },
        {
          text: 'Translation',
          href: '/translation',
        },
        {
          text: 'Parallel View\n(Edition & Translation)',
          href: '/parallel',
        },
        {
          text: 'Glossary',
          href: '/glossary',
        },
      ],
    }),
  }
</script>
