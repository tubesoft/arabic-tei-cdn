<template>
<div>
  <v-navigation-drawer
    v-model="drawer"
    :mini-variant.sync="mini"
    permanent
    class="sticky-menu"
  >
    <v-list-item class="px-2">
      <v-list-item-avatar>
        <v-btn v-if="mini == true" @click.stop="mini = !mini" icon>
          <v-icon>mdi-chevron-right</v-icon>
        </v-btn>
      </v-list-item-avatar>

      <v-list-item-title>Texts</v-list-item-title>

      <v-btn icon @click.stop="mini = !mini">
        <v-icon>mdi-chevron-left</v-icon>
      </v-btn>
    </v-list-item>

    <v-divider></v-divider>

    <v-list dense>
      <v-list-item v-for="item in editionlist"
        :key="item.title"
        link
        @click.stop="mini = !mini"
        @click="converting(item.xml,item.xsl)"
        :disabled="mini"
      >
        <v-list-item-icon>
          <v-icon v-if="!mini">mdi-book-open-variant</v-icon>
        </v-list-item-icon>

        <v-list-item-content>
          <v-list-item-title>{{ item.title }}</v-list-item-title>
          <v-list-item-subtitle>{{ item.author }}</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>

  <div ref="parent">
    <convertedTemplete />
  </div>

</div>
</template>
<script>
var convertedTemplete = {
  template: '<div></div>'
}

export default {
  name: "Edition",
  components: {
    convertedTemplete
  },
  methods: {
    getConvertedText: async function() {
      try {
        const responseXML = await fetch('../assets/tei/' + this.xml + '.xml')
        const xml = new DOMParser().parseFromString(await responseXML.text(), 'text/xml')
        const responseXSL = await fetch('../assets/xslt/' + this.xsl + '.xsl')
        const xsl = new DOMParser().parseFromString(await responseXSL.text(), 'text/xml')

        var xsltProcessor = new XSLTProcessor()
        xsltProcessor.importStylesheet(xsl)
        var doc = xsltProcessor.transformToDocument(xml)


        while (!!doc.getElementById('vslot')) {
          doc.getElementById('vslot').setAttribute('v-slot:activator','{ on, attrs }')
          doc.getElementById('vslot').removeAttribute('id')
        }
        while (!!doc.getElementById('v-menu-config')) {
          doc.getElementById('v-menu-config').setAttribute(':nudge-width','150')
          doc.getElementById('v-menu-config').setAttribute(':close-on-content-click',"false")
          doc.getElementById('v-menu-config').setAttribute(':dark',this.$vuetify.theme.dark)
          doc.getElementById('v-menu-config').removeAttribute('id')
        }

        var result = doc.documentElement.outerHTML
        var isDark = ""
        if (this.$vuetify.theme.dark) {
          isDark = "dark"
        } else {
          isDark = "light"
        }
        console.log(result);
        convertedTemplete = {
          vuetify: new Vuetify({}),
          template: "<v-theme-provider " + isDark + ">" + result + "</v-theme-provider>",
        }
        //コンポーネントの再読み込み
        this.$refs["parent"].textContent = null;
        const ComponentClass = Vue.extend(convertedTemplete);
        const instance = new ComponentClass();
        instance.$mount();
        this.$refs["parent"].appendChild(instance.$el);

      } catch (err) {
        console.error(err)
      }
    },
    converting: function(xml, xsl) {
      this.xml = xml
      this.xsl = xsl
      this.getConvertedText()
    }
  },
  data: function() {
    return {
      xml: "",
      xsl: "",
      drawer: true,
      mini: false,
      hover: false,
    }
  },
  props: {
    editionlist: Array,
  },
}
</script>
