<template>
  <v-container :v-if="render">
      <b>{{ text }}</b>
      <!-- <v-row class="text-center mb-10">
        <v-col class="text-h2">About this website</v-col>
      </v-row>

      <v-expansion-panels multiple>
        <v-expansion-panel
          v-for="(next, i) in contents"
          :key="i"
        >
          <v-expansion-panel-header class="text-h5">
            {{ next.header }}
          </v-expansion-panel-header>
          <v-expansion-panel-content>
            <component v-bind:is="next.content"></component>
          </v-expansion-panel-content>
        </v-expansion-panel>
      </v-expansion-panels> -->
  </v-container>
</template>
<script>

export default {
  data: function() {
    return {
      text: 'Under Construction',
      render: false,
      contents: [
        {
          header: 'Dissertation Project',
          content: {
            template: `
              <div>
                <p>
                  Takatomo Inoue, Ph.D. Candidate in History and Philosophy of Science and Medicine,
                  Indiana University, Bloomington, is working on his dissertation on
                  alchemy in medieval Islam, particularly focused on Abū Bakr al-Rāzī (d. 925).
                </p>
                <p>
                  As a part of the dissertion project, Inoue is editing and translating
                  relevant manuscripts using TEI P5 encording and Vue.js front end framework.
                </p>
              </div>
            `,
          },
        },
        {
          header: 'Guide to the Website',
          content: {
            template: `
              <div>
                <h3>Edition</h3>

                <h3>Translation</h3>

                <h3>Parallel View</h3>

              </div>
            `,
          },
        },
        {
          header: 'Editing Methodology',
          content: {
            template: `
              <div>

              </div>
            `,
          },
        },
        {
          header: 'Short Bio',
          content: {
            template: `
              <div>

              </div>
            `,
          },
        },
      ],
    }
  }
}
</script>
